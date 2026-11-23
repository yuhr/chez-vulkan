;;; Generates vulkan.ss, xlib.ss, xcb.ss and wayland.ss from res/vulkan.xml.
;;;
;;; res/vulkan.xml is produced by castxml from the system Vulkan headers,
;;; with the Linux window-system platforms enabled (needs the X11, Xrandr,
;;; xcb and Wayland development headers):
;;;
;;;   castxml --castxml-gccxml -DVK_USE_PLATFORM_XLIB_KHR \
;;;     -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -DVK_USE_PLATFORM_XCB_KHR \
;;;     -DVK_USE_PLATFORM_WAYLAND_KHR -o res/vulkan.xml /usr/include/vulkan/vulkan.h
;;;
;;; then run this file from the repository root:
;;;
;;;   scheme --script generate-vulkan.ss
;;;
;;; win32.ss comes from a separate parse for 64-bit Windows (MSVC ABI), made
;;; by res/make-win32-xml.sh from the Windows SDK and MSVC headers:
;;;
;;;   scheme --script generate-vulkan.ss res/vulkan-win32.xml
;;;
;;; Each run writes the libraries whose headers are in its input.  The
;;; Windows parse (recognized by vulkan_win32.h) does not rewrite vulkan.ss:
;;; the core library generated from it must be identical to the existing
;;; vulkan.ss, or the run fails.
;;;
;;; Functions every Vulkan loader exports (core 1.0-1.4 and the standard
;;; window-system extensions, decided from the header section each one is
;;; declared in) are bound directly; all other functions get a vk:load-*
;;; procedure that fetches them with vkGet*ProcAddr.  The headers must be
;;; where castxml read them.  The local loader is only used for a
;;; cross-check, so the output does not depend on its version.  After
;;; writing the libraries, every generated struct/union is checked against
;;; the sizes and field offsets castxml reported.

(import (chezscheme))

(define loader-name "libvulkan.so.1")   ; only for cross-checking exports
(define default-input "res/vulkan.xml")
(define input-file
  (let ((args (command-line-arguments)))
    (if (pair? args) (car args) default-input)))

;; Each generated library: its name, output file and the Vulkan headers
;; whose declarations it holds.  Platform libraries import (vulkan).
(define libraries
  '((core    (vulkan)         "vulkan.ss"  ("vulkan_core.h" "vulkan.h" "vk_platform.h" "vk_video/"))
    (xlib    (vulkan xlib)    "xlib.ss"    ("vulkan_xlib.h" "vulkan_xlib_xrandr.h"))
    (xcb     (vulkan xcb)     "xcb.ss"     ("vulkan_xcb.h"))
    (wayland (vulkan wayland) "wayland.ss" ("vulkan_wayland.h"))
    (win32   (vulkan win32)   "win32.ss"   ("vulkan_win32.h"))))

;;; ------------------------------------------------------------------
;;; Minimal XML reader (sufficient for castxml output: elements and
;;; attributes, no text content).

(define-record-type node
  (fields tag attrs (mutable children))
  (protocol (lambda (new) (lambda (tag attrs) (new tag attrs '())))))

(define (attr n name)
  (let ((p (assq name (node-attrs n))))
    (and p (cdr p))))

(define (xml-unescape s)
  (if (not (memv #\& (string->list s)))
      s
      (let loop ((i 0) (acc '()))
        (if (>= i (string-length s))
            (list->string (reverse acc))
            (let ((c (string-ref s i)))
              (if (char=? c #\&)
                  (let* ((j (let find ((j i))
                              (if (char=? (string-ref s j) #\;) j (find (+ j 1)))))
                         (ent (substring s (+ i 1) j))
                         (ch (cond
                              ((string=? ent "lt") #\<)
                              ((string=? ent "gt") #\>)
                              ((string=? ent "amp") #\&)
                              ((string=? ent "quot") #\")
                              ((string=? ent "apos") #\')
                              ((and (> (string-length ent) 1)
                                    (char=? (string-ref ent 0) #\#))
                               (integer->char
                                (if (char=? (string-ref ent 1) #\x)
                                    (string->number (substring ent 2 (string-length ent)) 16)
                                    (string->number (substring ent 1 (string-length ent))))))
                              (else (error 'xml-unescape "unknown entity" ent)))))
                    (loop (+ j 1) (cons ch acc)))
                  (loop (+ i 1) (cons c acc))))))))

(define (read-xml path)
  (let* ((s (call-with-input-file path get-string-all))
         (len (string-length s))
         (root (make-node 'root '())))
    (define (skip-ws i)
      (if (and (< i len) (char-whitespace? (string-ref s i))) (skip-ws (+ i 1)) i))
    (define (name-end i)
      (if (and (< i len)
               (let ((c (string-ref s i)))
                 (not (or (char-whitespace? c) (memv c '(#\= #\/ #\> #\"))))))
          (name-end (+ i 1))
          i))
    (define (find-char c i)
      (if (char=? (string-ref s i) c) i (find-char c (+ i 1))))
    (define (find-string str i)
      (let ((k (string-length str)))
        (let loop ((i i))
          (if (string=? (substring s i (+ i k)) str) i (loop (+ i 1))))))
    (let loop ((i 0) (stack (list root)))
      (let ((lt (let find ((i i))
                  (cond ((>= i len) #f)
                        ((char=? (string-ref s i) #\<) i)
                        (else (find (+ i 1)))))))
        (cond
         ((not lt)
          (for-each (lambda (n) (node-children-set! n (reverse (node-children n))))
                    stack)
          root)
         ((char=? (string-ref s (+ lt 1)) #\?)
          (loop (+ (find-string "?>" lt) 2) stack))
         ((char=? (string-ref s (+ lt 1)) #\!)
          (loop (+ (find-char #\> lt) 1) stack))
         ((char=? (string-ref s (+ lt 1)) #\/)
          (let ((n (car stack)))
            (node-children-set! n (reverse (node-children n)))
            (loop (+ (find-char #\> lt) 1) (cdr stack))))
         (else
          (let* ((ne (name-end (+ lt 1)))
                 (tag (string->symbol (substring s (+ lt 1) ne))))
            (let attrs ((i (skip-ws ne)) (as '()))
              (let ((c (string-ref s i)))
                (cond
                 ((char=? c #\/)
                  (let ((n (make-node tag (reverse as))))
                    (node-children-set! (car stack) (cons n (node-children (car stack))))
                    (loop (+ (find-char #\> i) 1) stack)))
                 ((char=? c #\>)
                  (let ((n (make-node tag (reverse as))))
                    (node-children-set! (car stack) (cons n (node-children (car stack))))
                    (loop (+ i 1) (cons n stack))))
                 (else
                  (let* ((ae (name-end i))
                         (aname (string->symbol (substring s i ae)))
                         (q1 (find-char #\" ae))
                         (q2 (find-char #\" (+ q1 1))))
                    (attrs (skip-ws (+ q2 1))
                           (cons (cons aname (xml-unescape (substring s (+ q1 1) q2)))
                                 as))))))))))))))

;;; ------------------------------------------------------------------
;;; String helpers and name mangling (kept identical to the original
;;; generator so exported names stay stable).

(define (string-prefix? p s)
  (and (<= (string-length p) (string-length s))
       (string=? p (substring s 0 (string-length p)))))

(define (string-suffix? p s)
  (let ((lp (string-length p)) (ls (string-length s)))
    (and (<= lp ls) (string=? p (substring s (- ls lp) ls)))))

(define (string-search pat s)
  (let ((lp (string-length pat)) (ls (string-length s)))
    (let loop ((i 0))
      (cond ((> (+ i lp) ls) #f)
            ((string=? pat (substring s i (+ i lp))) i)
            (else (loop (+ i 1)))))))

(define (split-alnum str)
  (let loop ((cs (string->list str)) (cur '()) (acc '()))
    (define (flush) (if (null? cur) acc (cons (list->string (reverse cur)) acc)))
    (cond
     ((null? cs) (reverse (flush)))
     ((or (char-alphabetic? (car cs)) (char-numeric? (car cs)))
      (loop (cdr cs) (cons (car cs) cur) acc))
     (else (loop (cdr cs) '() (flush))))))

(define (join strs sep)
  (if (null? strs)
      ""
      (apply string-append (car strs)
             (map (lambda (s) (string-append sep s)) (cdr strs)))))

;; VK_FOO_BAR -> vk:foo-bar
(define (vk-enum-symbol str)
  (let ((dstr (string-downcase (join (split-alnum str) "-"))))
    (string->symbol
     (if (string-prefix? "vk-" dstr)
         (string-append "vk:" (substring dstr 3 (string-length dstr)))
         dstr))))

;; VkFooBar -> vk:foo-bar ; a dash is inserted before every upper-case
;; letter that does not follow another upper-case letter.
(define (vk-symbol str)
  (let loop ((cs (string->list str)) (prev #f) (acc '()))
    (if (null? cs)
        (vk-enum-symbol (list->string (reverse acc)))
        (let ((c (car cs)))
          (loop (cdr cs) c
                (if (and prev (char-upper-case? c) (not (char-upper-case? prev)))
                    (cons c (cons #\- acc))
                    (cons c acc)))))))

;;; ------------------------------------------------------------------
;;; Load the castxml tree.

(define doc
  (let ((root (read-xml input-file)))
    (let ((top (find (lambda (n) (memq (node-tag n) '(GCC_XML CastXML)))
                     (node-children root))))
      (or top (error 'generate "no GCC_XML/CastXML root element" input-file)))))

(define by-id (make-hashtable string-hash string=?))
(for-each (lambda (n) (let ((id (attr n 'id))) (when id (hashtable-set! by-id id n))))
          (node-children doc))

(define (lookup id)
  (or (hashtable-ref by-id id #f) (error 'generate "unknown id" id)))

;; File id -> the library (core, xlib, ...) its declarations belong to.
;; Only vulkan/*.h and vk_video/*.h files are Vulkan's own.
(define file-libraries
  (let ((ht (make-hashtable string-hash string=?)))
    (for-each
     (lambda (n)
       (when (eq? (node-tag n) 'File)
         (let ((name (attr n 'name)))
           (when (or (string-search "/vulkan/" name) (string-search "/vk_video/" name))
             (let ((lib (find (lambda (l)
                                (exists (lambda (pat)
                                          (if (string-suffix? "/" pat)
                                              (string-search (string-append "/" pat) name)
                                              (string-suffix? (string-append "/" pat) name)))
                                        (cadddr l)))
                              libraries)))
               (if lib
                   (hashtable-set! ht (attr n 'id) (car lib))
                   (printf "note: ignoring ~a (no library for it)\n" name)))))))
     (node-children doc))
    ht))

(define (node-library n)
  (let ((f (attr n 'file))) (and f (hashtable-ref file-libraries f #f))))

(define (vulkan-node? n) (and (node-library n) #t))

;; Enum/flag value names.  A handful of structs mangle to the same symbol
;; as an enum value (e.g. VkPipelineCacheHeaderVersionOne vs.
;; VK_PIPELINE_CACHE_HEADER_VERSION_ONE); those types get a -struct suffix.
(define value-names
  (let ((ht (make-eq-hashtable)))
    (for-each (lambda (n)
                (when (vulkan-node? n)
                  (case (node-tag n)
                    ((Enumeration)
                     (for-each (lambda (v)
                                 (when (eq? (node-tag v) 'EnumValue)
                                   (hashtable-set! ht (vk-enum-symbol (attr v 'name)) #t)))
                               (node-children n)))
                    ((Variable) (hashtable-set! ht (vk-enum-symbol (attr n 'name)) #t)))))
              (node-children doc))
    ht))

(define (type-symbol name)
  (let ((sym (vk-symbol name)))
    (if (hashtable-ref value-names sym #f)
        (string->symbol (string-append (symbol->string sym) "-struct"))
        sym)))

;;; ------------------------------------------------------------------
;;; Type translation.

;; Integer types are mapped by their size, not their C name: `long' is
;; 64 bits on Linux but 32 bits on Windows.
(define (fundamental->ftype n)
  (let ((name (attr n 'name)) (size (attr n 'size)))
    (cond
     ((member name '("float" "double" "void" "char")) (string->symbol name))
     ((member name '("signed char" "unsigned char" "short int" "short unsigned int"
                     "int" "unsigned int" "long int" "long unsigned int"
                     "long long int" "long long unsigned int"))
      (string->symbol (format "~a-~a" (if (string-search "unsigned" name) "unsigned" "integer") size)))
     (else (error 'generate "unsupported fundamental type" name)))))

;; Strip typedefs and qualifiers down to a FundamentalType/Enumeration node.
(define (underlying n)
  (case (node-tag n)
    ((Typedef CvQualifiedType ElaboratedType) (underlying (lookup (attr n 'type))))
    (else n)))

;; Forms are emitted into the library being generated; `defined' spans
;; all libraries, so platform libraries refer to (vulkan)'s types.
(define output '())          ; generated forms of the current library, reversed
(define exported '())        ; its vk:* symbols, reversed
(define all-forms '())       ; every library's forms, in order, for the layout check
(define defined (make-eq-hashtable))   ; symbol -> #t once its form is emitted
(define layouts '())         ; (symbol size-in-bits ((field-sym . offset) ...)) for checking

(define (emit! form)
  (set! output (cons form output))
  (set! all-forms (cons form all-forms))
  (when (and (pair? form) (memq (car form) '(define define-ftype define-vk-procedure define-vk-loader)))
    (let ((name (cadr form)))
      (when (hashtable-ref defined name #f)
        (error 'generate "duplicate definition" name))
      (hashtable-set! defined name #t)
      (when (string-prefix? "vk:" (symbol->string name))
        (set! exported (cons name exported))))))

(define (named? n) (let ((nm (attr n 'name))) (and nm (not (string=? nm "")))))

;; Translate the type with the given id to an ftype expression, emitting
;; definitions for any named types it depends on first.
(define (type->ftype id)
  (let ((n (lookup id)))
    (case (node-tag n)
      ((FundamentalType) (fundamental->ftype n))
      ((CvQualifiedType ElaboratedType) (type->ftype (attr n 'type)))
      ((PointerType) 'uptr)
      ((ArrayType)
       (let ((max (attr n 'max)))
         `(array ,(if (or (not max) (string=? max "")) 0 (+ (string->number max) 1))
                 ,(type->ftype (attr n 'type)))))
      ;; System typedefs (uint32_t, size_t, ...) are resolved to base ftypes.
      ((Typedef)
       (if (vulkan-node? n)
           (begin (ensure-defined! n) (type-symbol (attr n 'name)))
           (type->ftype (attr n 'type))))
      ((Struct Union Enumeration)
       (if (named? n)
           (begin (ensure-defined! n) (type-symbol (attr n 'name)))
           (record-body n)))        ; anonymous struct/union: inline
      (else (error 'generate "unsupported type node" (node-tag n) id)))))

(define (ensure-defined! n)
  (let ((sym (type-symbol (attr n 'name))))
    (unless (hashtable-ref defined sym #f)
      (case (node-tag n)
        ((Typedef)
         (let ((target (lookup (attr n 'type))))
           (if (and (memq (node-tag target) '(Struct Union Enumeration))
                    (equal? (attr target 'name) (attr n 'name)))
               (ensure-defined! target)
               (unless (and (memq (node-tag target) '(Struct Union))
                            (attr target 'incomplete))
                 (emit! `(define-ftype ,sym ,(type->ftype (attr n 'type))))))))
        ((Enumeration)
         (emit! `(define-ftype ,sym enum))
         (for-each (lambda (v)
                     (when (eq? (node-tag v) 'EnumValue)
                       (emit! `(define ,(vk-enum-symbol (attr v 'name))
                                 ,(string->number (attr v 'init))))))
                   (node-children n)))
        ((Struct Union)
         (if (attr n 'incomplete)
             (error 'generate "incomplete type used by value" (attr n 'name))
             (let ((body (record-body n)))
               (emit! `(define-ftype ,sym ,body))
               (set! layouts
                     (cons (list sym (string->number (attr n 'size)) (record-offsets n))
                           layouts)))))))))

(define (record-fields n)
  (let ((members (attr n 'members)))
    (if (not members)
        '()
        (filter (lambda (m) (eq? (node-tag m) 'Field))
                (map lookup (split-ws members))))))

(define (split-ws s)
  (let loop ((cs (string->list s)) (cur '()) (acc '()))
    (define (flush) (if (null? cur) acc (cons (list->string (reverse cur)) acc)))
    (cond ((null? cs) (reverse (flush)))
          ((char-whitespace? (car cs)) (loop (cdr cs) '() (flush)))
          (else (loop (cdr cs) (cons (car cs) cur) acc)))))

;; Non-bitfield field offsets (in bits) as reported by castxml.
(define (record-offsets n)
  (fold-right (lambda (f acc)
                (if (or (attr f 'bits) (not (named? f)))
                    acc
                    (cons (cons (vk-symbol (attr f 'name)) (string->number (attr f 'offset)))
                          acc)))
              '()
              (record-fields n)))

;; Builds (struct ...) / (union ...).  Runs of C bitfields are packed into
;; ftype (bits ...) groups whose width is the declared storage type's width.
(define (record-body n)
  (let ((kind (if (eq? (node-tag n) 'Union) 'union 'struct)))
    (let loop ((fs (record-fields n)) (acc '()) (groups 0))
      (cond
       ((null? fs) `(,kind ,@(reverse acc)))
       ((attr (car fs) 'bits)
        (let* ((u (underlying (lookup (attr (car fs) 'type))))
               (width (string->number (attr u 'size)))
               (signed (if (and (eq? (node-tag u) 'FundamentalType)
                                (not (string-search "unsigned" (attr u 'name))))
                           'signed 'unsigned)))
          (let group ((fs fs) (used 0) (bits '()))
            (let ((f (and (pair? fs) (car fs))))
              (if (and f (attr f 'bits)
                       (= width (string->number (attr (underlying (lookup (attr f 'type))) 'size)))
                       (<= (+ used (string->number (attr f 'bits))) width))
                  (let ((b (string->number (attr f 'bits))))
                    (group (cdr fs) (+ used b)
                           (cons (list (vk-symbol (attr f 'name)) signed b) bits)))
                  (let ((bits (if (< used width)
                                  (cons (list '_ 'unsigned (- width used)) bits)
                                  bits)))
                    ;; C bitfields have no ftype equivalent outside a named
                    ;; (bits ...) container: access as (ftype-ref T (bits-N field) p).
                    (loop fs
                          (cons `(,(string->symbol (format "bits-~a" groups)) (bits ,@(reverse bits)))
                                acc)
                          (+ groups 1))))))))
       (else
        (let ((f (car fs)))
          (loop (cdr fs)
                (cons (list (vk-symbol (attr f 'name)) (type->ftype (attr f 'type))) acc)
                groups)))))))

;; Argument/return types: struct values need (& T).
(define (param-type id)
  (let ((n (underlying (lookup id))))
    (let ((t (type->ftype id)))
      (if (memq (node-tag n) '(Struct Union)) `(& ,t) t))))

;;; ------------------------------------------------------------------
;;; Generate.

(define have-loader?
  (guard (e (#t (printf "note: no ~a here; skipping the export cross-check\n" loader-name) #f))
    (load-shared-object loader-name)
    #t))

;; Functions exported by the loader are bound directly.  The rest
;; (extension functions) get a vk:load-* procedure that fetches the entry
;; point with vkGetDeviceProcAddr (device-level: first parameter is a
;; VkDevice, VkQueue or VkCommandBuffer) or vkGetInstanceProcAddr.
(define (device-level? fn)
  (let ((args (filter (lambda (c) (eq? (node-tag c) 'Argument)) (node-children fn))))
    (and (pair? args)
         (let strip ((t (lookup (attr (car args) 'type))))
           (case (node-tag t)
             ((CvQualifiedType) (strip (lookup (attr t 'type))))
             ((Typedef) (member (attr t 'name) '("VkDevice" "VkQueue" "VkCommandBuffer")))
             (else #f))))))

(define (loader-symbol name)
  (let ((s (symbol->string (vk-symbol name))))
    (string->symbol (string-append "vk:load-" (substring s 3 (string-length s))))))

;; The section (VK_VERSION_1_3, VK_KHR_swapchain, ...) each function is
;; declared in: the last "#define VK_xxx 1" before it in its header.
(define section-starts                  ; file id -> ((line . section) ...), descending
  (let ((ht (make-hashtable string-hash string=?)))
    (for-each
     (lambda (n)
       (when (and (eq? (node-tag n) 'File) (hashtable-ref file-libraries (attr n 'id) #f))
         (let ((path (attr n 'name)))
           (unless (file-exists? path)
             (error 'generate "header not found; regenerate res/vulkan.xml on this machine" path))
           (call-with-input-file path
             (lambda (in)
               (let loop ((line 1) (acc '()))
                 (let ((text (get-line in)))
                   (if (eof-object? text)
                       (hashtable-set! ht (attr n 'id) acc)
                       (loop (+ line 1)
                             (let ((words (split-ws text)))
                               ;; Section markers are VK_VERSION_x_y and extension
                               ;; names, which have lower-case letters (VK_KHR_surface);
                               ;; not e.g. VK_KHR_SURFACE_SPEC_VERSION 1.
                               (if (and (= (length words) 3)
                                        (string=? (car words) "#define")
                                        (string=? (caddr words) "1")
                                        (let ((name (cadr words)))
                                          (or (string-prefix? "VK_VERSION_" name)
                                              (and (string-prefix? "VK_" name)
                                                   (exists char-lower-case? (string->list name))))))
                                   (cons (cons line (cadr words)) acc)
                                   acc)))))))))))
     (node-children doc))
    ht))

(define (function-section fn)
  (let ((line (string->number (attr fn 'line))))
    (let ((hit (find (lambda (p) (< (car p) line))
                     (hashtable-ref section-starts (attr fn 'file) '()))))
      (and hit (cdr hit)))))

;; What every Vulkan loader exports: the core versions, the generic
;; window-system extensions and each platform's surface extension.
(define (loader-export? fn)
  (let ((section (function-section fn)))
    (and section
         (or (string-prefix? "VK_VERSION_" section)
             (member section '("VK_KHR_surface" "VK_KHR_swapchain" "VK_KHR_display"
                               "VK_KHR_display_swapchain" "VK_KHR_get_display_properties2"
                               "VK_KHR_get_surface_capabilities2" "VK_EXT_headless_surface"))
             (and (string-prefix? "VK_KHR_" section) (string-suffix? "_surface" section))))))

;; static const VkFlags64 values: "32ULL", "0x1ULL", ...
(define (parse-constant n)
  (let* ((init (attr n 'init))
         (digits (let strip ((s init))
                   (if (and (> (string-length s) 0)
                            (memv (string-ref s (- (string-length s) 1)) '(#\u #\U #\l #\L)))
                       (strip (substring s 0 (- (string-length s) 1)))
                       s)))
         (value (if (string-prefix? "0x" digits)
                    (string->number (substring digits 2 (string-length digits)) 16)
                    (string->number digits))))
    (or value (error 'generate "cannot parse constant" (attr n 'name) init))))

(define warnings 0)

;; Emit LIB's types, constants and functions => (values exports body).
(define (generate-library! lib)
  (set! output '())
  (set! exported '())
  (when (eq? lib 'core) (emit! '(define-ftype enum int)))
  ;; Types and enum values, in header order (dependencies first).
  (for-each (lambda (n)
              (when (and (eq? (node-library n) lib) (named? n)
                         (memq (node-tag n) '(Typedef Enumeration Struct Union))
                         (not (attr n 'incomplete)))
                (ensure-defined! n)))
            (node-children doc))
  ;; static const VkFlags64 constants (64-bit flag bits).
  (for-each (lambda (n)
              (when (and (eq? (node-tag n) 'Variable) (eq? (node-library n) lib) (attr n 'init))
                (emit! `(define ,(vk-enum-symbol (attr n 'name)) ,(parse-constant n)))))
            (node-children doc))
  (for-each (lambda (n)
              (when (and (eq? (node-tag n) 'Function) (eq? (node-library n) lib))
                (let* ((name (attr n 'name))
                       (args (map (lambda (a) (param-type (attr a 'type)))
                                  (filter (lambda (c) (eq? (node-tag c) 'Argument))
                                          (node-children n))))
                       (ret (param-type (attr n 'returns)))
                       (direct? (and (loader-export? n) #t)))
                  ;; Advisory only: an older local loader lacks newer functions
                  ;; (they then fail when called), a newer one may export more.
                  ;; (A Linux loader cannot speak for (vulkan win32).)
                  (when (and have-loader? (not (eq? lib 'win32))
                             (not (eq? direct? (foreign-entry? name))))
                    (set! warnings (+ warnings 1))
                    (printf "note: ~a is bound ~a, but the local loader ~a it\n" name
                            (if direct? "directly" "through vk:load-*")
                            (if (foreign-entry? name) "exports" "does not export")))
                  (when direct?
                    (emit! `(define-vk-procedure ,(vk-symbol name) ,name ,args ,ret)))
                  ;; Every function also gets a vk:load-*, so a function newer
                  ;; than the installed loader can still be fetched from the driver.
                  (emit! `(define-vk-loader ,(loader-symbol name)
                            ,(if (device-level? n) 'device-proc-addr 'instance-proc-addr)
                            ,name ,args ,ret)))))
            (node-children doc))
  (values (reverse exported) (reverse output)))

;; Shared by every generated library: load the Vulkan loader (by its name on
;; this platform) and the two ways of binding a function.
(define prelude
  '((define loader
      (let* ((mt (symbol->string (machine-type)))
             (os? (lambda (suffix)
                    (let ((n (string-length mt)) (k (string-length suffix)))
                      (and (>= n k) (string=? suffix (substring mt (- n k) n))))))
             (candidates
              (cond ((os? "nt") '("vulkan-1.dll"))
                    ((os? "osx") '("libvulkan.1.dylib" "/usr/local/lib/libvulkan.1.dylib"
                                   "/opt/homebrew/lib/libvulkan.1.dylib" "libMoltenVK.dylib"))
                    (else '("libvulkan.so.1" "libvulkan.so")))))
        (let try ((names candidates))
          (cond ((null? names) (error 'vulkan "cannot load the Vulkan loader; tried" candidates))
                ((guard (e (#t #f)) (load-shared-object (car names)) #t) (car names))
                (else (try (cdr names)))))))
    ;; Bind lazily-checked: a missing entry (older loader) only errors when called.
    (define-syntax define-vk-procedure
      (syntax-rules ()
        ((_ name cname args ret)
         (define name
           (if (foreign-entry? cname)
               (foreign-procedure cname args ret)
               (lambda rest
                 (error 'name "not exported by the Vulkan loader" cname)))))))
    (define instance-proc-addr
      (foreign-procedure "vkGetInstanceProcAddr" (uptr utf-8) uptr))
    (define device-proc-addr
      (foreign-procedure "vkGetDeviceProcAddr" (uptr utf-8) uptr))
    ;; (name handle) => procedure, or #f when the driver/loader does not
    ;; provide the function (e.g. the extension is not enabled).
    (define-syntax define-vk-loader
      (syntax-rules ()
        ((_ name get-proc-addr cname args ret)
         (define (name handle)
           (let ((addr (get-proc-addr handle cname)))
             (and (not (zero? addr))
                  (foreign-procedure addr args ret)))))))))

(define (count-forms head body)
  (length (filter (lambda (f) (and (pair? f) (eq? (car f) head))) body)))

(define (library-text lib name exports body)
  (call-with-string-output-port
   (lambda (out)
     (display ";;; Generated by generate-vulkan.ss from res/vulkan.xml -- do not edit.\n" out)
     (parameterize ((print-radix 10))
       (pretty-print
        `(library ,name
           (export ,@exports)
           (import (chezscheme) ,@(if (eq? lib 'core) '() '((vulkan))))
           ,@prelude
           ;; (vulkan) defines `enum' itself; it is not exported.
           ,@(if (eq? lib 'core) '() '((define-ftype enum int)))
           ,@body)
        out)))))

(define (in-input? lib)
  (let-values (((ids libs) (hashtable-entries file-libraries)))
    (exists (lambda (l) (eq? l lib)) (vector->list libs))))

(for-each
 (lambda (l)
   (let ((lib (car l)) (name (cadr l)) (file (caddr l)))
     (when (in-input? lib)
       (let-values (((exports body) (generate-library! lib)))
         (let ((text (library-text lib name exports body)))
           (cond
            ;; The Windows parse (it has vulkan_win32.h) only checks the core.
            ((and (eq? lib 'core) (in-input? 'win32))
             ;; A second parse must agree with the one vulkan.ss came from.
             (if (and (file-exists? file)
                      (string=? text (call-with-input-file file get-string-all)))
                 (printf "~a: the core library from ~a is identical to ~a\n" input-file input-file file)
                 (begin (printf "error: the core library from ~a differs from ~a\n" input-file file)
                        (exit 1))))
            (else
             (call-with-output-file file (lambda (out) (display text out)) 'truncate)
             (printf "wrote ~a: ~a exports, ~a functions bound, ~a extension loaders\n"
                     file (length exports)
                     (count-forms 'define-vk-procedure body) (count-forms 'define-vk-loader body)))))))))
 libraries)

;;; ------------------------------------------------------------------
;;; Verify ftype layouts against castxml.

(let ((env (copy-environment (scheme-environment) #t)))
  (for-each (lambda (form)
              (when (and (pair? form) (eq? (car form) 'define-ftype))
                (eval form env)))
            (reverse all-forms))
  (let ((errors 0))
    (for-each
     (lambda (l)
       (let ((sym (car l)) (size (cadr l)) (offsets (caddr l)))
         (let ((got (* 8 (eval `(ftype-sizeof ,sym) env))))
           (unless (= got size)
             (set! errors (+ errors 1))
             (printf "size mismatch ~a: ftype ~a bits, C ~a bits\n" sym got size)))
         (for-each
          (lambda (fo)
            (let ((got (* 8 (eval `(let ((p (make-ftype-pointer ,sym 0)))
                                     (ftype-pointer-address (ftype-&ref ,sym (,(car fo)) p)))
                                  env))))
              (unless (= got (cdr fo))
                (set! errors (+ errors 1))
                (printf "offset mismatch ~a.~a: ftype ~a, C ~a\n" sym (car fo) got (cdr fo)))))
          offsets)))
     layouts)
    (printf "checked ~a struct/union layouts: ~a mismatches\n" (length layouts) errors)
    (unless (zero? warnings)
      (printf "~a functions differ from the local loader's exports (see notes above)\n" warnings))
    (unless (zero? errors) (exit 1))))
