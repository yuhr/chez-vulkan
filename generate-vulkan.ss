;;; Generates vulkan.ss from res/vulkan.xml.
;;;
;;; res/vulkan.xml is produced by castxml from the system Vulkan headers:
;;;
;;;   castxml --castxml-gccxml -o res/vulkan.xml /usr/include/vulkan/vulkan.h
;;;
;;; then run this file from the repository root:
;;;
;;;   scheme --script generate-vulkan.ss
;;;
;;; Only functions exported by the local Vulkan loader (libvulkan.so.1) are
;;; bound; extension functions must be fetched with vkGet*ProcAddr.
;;; After writing vulkan.ss, every generated struct/union is checked against
;;; the sizes and field offsets castxml reported.

(import (chezscheme))

(define loader-name "libvulkan.so.1")
(define input-file "res/vulkan.xml")
(define output-file "vulkan.ss")

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

;; Files that belong to the Vulkan API (vulkan/*.h and vk_video/*.h).
(define vulkan-files
  (let ((ht (make-hashtable string-hash string=?)))
    (for-each (lambda (n)
                (when (and (eq? (node-tag n) 'File)
                           (let ((name (attr n 'name)))
                             (or (string-search "/vulkan/" name)
                                 (string-search "/vk_video/" name))))
                  (hashtable-set! ht (attr n 'id) #t)))
              (node-children doc))
    ht))

(define (vulkan-node? n)
  (let ((f (attr n 'file))) (and f (hashtable-ref vulkan-files f #f))))

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

(define fundamental-types
  '(("signed char" . integer-8) ("unsigned char" . unsigned-8) ("char" . char)
    ("short int" . integer-16) ("short unsigned int" . unsigned-16)
    ("int" . integer-32) ("unsigned int" . unsigned-32)
    ("long int" . integer-64) ("long unsigned int" . unsigned-64)
    ("long long int" . integer-64) ("long long unsigned int" . unsigned-64)
    ("float" . float) ("double" . double) ("void" . void)))

(define (fundamental->ftype name)
  (let ((p (assoc name fundamental-types)))
    (if p (cdr p) (error 'generate "unsupported fundamental type" name))))

;; Strip typedefs and qualifiers down to a FundamentalType/Enumeration node.
(define (underlying n)
  (case (node-tag n)
    ((Typedef CvQualifiedType ElaboratedType) (underlying (lookup (attr n 'type))))
    (else n)))

(define output '())          ; generated forms, reversed
(define exported '())        ; vk:* symbols, reversed
(define defined (make-eq-hashtable))   ; symbol -> #t once its form is emitted
(define layouts '())         ; (symbol size-in-bits ((field-sym . offset) ...)) for checking

(define (emit! form)
  (set! output (cons form output))
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
      ((FundamentalType) (fundamental->ftype (attr n 'name)))
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

(load-shared-object loader-name)

(emit! '(define-ftype enum int))

;; Types and enum values, in header order (dependencies first).
(for-each (lambda (n)
            (when (and (vulkan-node? n) (named? n)
                       (memq (node-tag n) '(Typedef Enumeration Struct Union))
                       (not (attr n 'incomplete)))
              (ensure-defined! n)))
          (node-children doc))

;; static const VkFlags64 constants (64-bit flag bits).
(for-each (lambda (n)
            (when (and (eq? (node-tag n) 'Variable) (vulkan-node? n) (attr n 'init))
              (let* ((init (attr n 'init))
                     (digits (let strip ((s init))
                               (if (and (> (string-length s) 0)
                                        (memv (string-ref s (- (string-length s) 1))
                                              '(#\u #\U #\l #\L)))
                                   (strip (substring s 0 (- (string-length s) 1)))
                                   s)))
                     (value (cond
                             ((string-prefix? "0x" digits)
                              (string->number (substring digits 2 (string-length digits)) 16))
                             (else (string->number digits)))))
                (unless value (error 'generate "cannot parse constant" (attr n 'name) init))
                (emit! `(define ,(vk-enum-symbol (attr n 'name)) ,value)))))
          (node-children doc))

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

(for-each (lambda (n)
            (when (and (eq? (node-tag n) 'Function) (vulkan-node? n))
              (let ((name (attr n 'name))
                    (args (map (lambda (a) (param-type (attr a 'type)))
                               (filter (lambda (c) (eq? (node-tag c) 'Argument))
                                       (node-children n))))
                    (ret (param-type (attr n 'returns))))
                (if (foreign-entry? name)
                    (emit! `(define-vk-procedure ,(vk-symbol name) ,name ,args ,ret))
                    (emit! `(define-vk-loader ,(loader-symbol name)
                              ,(if (device-level? n) 'device-proc-addr 'instance-proc-addr)
                              ,name ,args ,ret))))))
          (node-children doc))

(define (count-forms head)
  (length (filter (lambda (f) (and (pair? f) (eq? (car f) head))) output)))

(define library-form
  `(library (vulkan)
     (export ,@(reverse exported))
     (import (chezscheme))
     (define loader (load-shared-object ,loader-name))
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
                   (foreign-procedure addr args ret)))))))
     ,@(reverse output)))

(call-with-output-file output-file
  (lambda (out)
    (display ";;; Generated by generate-vulkan.ss from res/vulkan.xml -- do not edit.\n" out)
    (parameterize ((print-radix 10))
      (pretty-print library-form out)))
  'truncate)

(printf "wrote ~a: ~a exports, ~a functions bound, ~a extension loaders\n"
        output-file (length exported)
        (count-forms 'define-vk-procedure) (count-forms 'define-vk-loader))

;;; ------------------------------------------------------------------
;;; Verify ftype layouts against castxml.

(let ((env (copy-environment (scheme-environment) #t)))
  (for-each (lambda (form)
              (when (and (pair? form) (eq? (car form) 'define-ftype))
                (eval form env)))
            (reverse output))
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
    (unless (zero? errors) (exit 1))))
