;;; Minimal Xlib bindings for the examples: one window, key presses,
;;; resizes and the window manager's close button.  Only libX11 is needed
;;; (on Wayland desktops it runs through XWayland).

(library (examples x11)
  (export x11-open-window x11-close-window x11-poll-events
          x11-window-display x11-window-id x11-window-size
          xk-escape xk-left xk-up xk-right xk-down
          ;; for layout checks
          x-any-event x-key-event x-configure-event x-client-message-event)
  (import (chezscheme))

  (define libx11 (load-shared-object "libX11.so.6"))

  ;; Xlib types: Window, Atom, KeySym and Time are unsigned long; Bool is int.
  (define-ftype x-any-event
    (struct (type int) (serial unsigned-long) (send-event int)
            (display uptr) (window unsigned-long)))
  (define-ftype x-key-event
    (struct (type int) (serial unsigned-long) (send-event int)
            (display uptr) (window unsigned-long) (root unsigned-long)
            (subwindow unsigned-long) (time unsigned-long)
            (x int) (y int) (x-root int) (y-root int)
            (state unsigned-int) (keycode unsigned-int) (same-screen int)))
  (define-ftype x-configure-event
    (struct (type int) (serial unsigned-long) (send-event int)
            (display uptr) (event unsigned-long) (window unsigned-long)
            (x int) (y int) (width int) (height int) (border-width int)
            (above unsigned-long) (override-redirect int)))
  (define-ftype x-client-message-event
    (struct (type int) (serial unsigned-long) (send-event int)
            (display uptr) (window unsigned-long) (message-type unsigned-long)
            (format int) (data (array 5 long))))

  (define xevent-size 192)              ; sizeof(XEvent) on LP64

  (define key-press 2)
  (define configure-notify 22)
  (define client-message 33)
  (define key-press-mask 1)
  (define structure-notify-mask (bitwise-arithmetic-shift-left 1 17))

  (define xk-escape #xff1b)
  (define xk-left #xff51)
  (define xk-up #xff52)
  (define xk-right #xff53)
  (define xk-down #xff54)

  (define XOpenDisplay (foreign-procedure "XOpenDisplay" (uptr) uptr))
  (define XCloseDisplay (foreign-procedure "XCloseDisplay" (uptr) int))
  (define XDefaultScreen (foreign-procedure "XDefaultScreen" (uptr) int))
  (define XRootWindow (foreign-procedure "XRootWindow" (uptr int) unsigned-long))
  (define XBlackPixel (foreign-procedure "XBlackPixel" (uptr int) unsigned-long))
  (define XCreateSimpleWindow
    (foreign-procedure "XCreateSimpleWindow"
                       (uptr unsigned-long int int unsigned-int unsigned-int
                             unsigned-int unsigned-long unsigned-long)
                       unsigned-long))
  (define XDestroyWindow (foreign-procedure "XDestroyWindow" (uptr unsigned-long) int))
  (define XStoreName (foreign-procedure "XStoreName" (uptr unsigned-long string) int))
  (define XSelectInput (foreign-procedure "XSelectInput" (uptr unsigned-long long) int))
  (define XInternAtom (foreign-procedure "XInternAtom" (uptr string int) unsigned-long))
  (define XSetWMProtocols
    (foreign-procedure "XSetWMProtocols" (uptr unsigned-long uptr int) int))
  (define XMapWindow (foreign-procedure "XMapWindow" (uptr unsigned-long) int))
  (define XFlush (foreign-procedure "XFlush" (uptr) int))
  (define XPending (foreign-procedure "XPending" (uptr) int))
  (define XNextEvent (foreign-procedure "XNextEvent" (uptr uptr) int))
  (define XLookupKeysym (foreign-procedure "XLookupKeysym" (uptr int) unsigned-long))

  (define-record-type x11-window
    (fields display id wm-delete event-buffer (mutable size)))

  (define (x11-open-window title width height)
    (let ((dpy (XOpenDisplay 0)))
      (when (zero? dpy)
        (error 'x11-open-window "cannot open X display (is DISPLAY set?)"))
      (let* ((screen (XDefaultScreen dpy))
             (win (XCreateSimpleWindow dpy (XRootWindow dpy screen) 0 0 width height 0
                                       (XBlackPixel dpy screen) (XBlackPixel dpy screen)))
             (wm-delete (XInternAtom dpy "WM_DELETE_WINDOW" 0))
             (atoms (foreign-alloc (ftype-sizeof unsigned-long))))
        (XStoreName dpy win title)
        (XSelectInput dpy win (bitwise-ior key-press-mask structure-notify-mask))
        (foreign-set! 'unsigned-long atoms 0 wm-delete)
        (XSetWMProtocols dpy win atoms 1)
        (foreign-free atoms)
        (XMapWindow dpy win)
        (XFlush dpy)
        (make-x11-window dpy win wm-delete (foreign-alloc xevent-size)
                         (cons width height)))))

  (define (x11-close-window w)
    (foreign-free (x11-window-event-buffer w))
    (XDestroyWindow (x11-window-display w) (x11-window-id w))
    (XCloseDisplay (x11-window-display w)))

  ;; Handle all pending events.  Calls (on-key keysym) for key presses and
  ;; (on-resize width height) when the size changes.  Returns #f once the
  ;; window manager asked to close the window, #t otherwise.
  (define (x11-poll-events w on-key on-resize)
    (let ((dpy (x11-window-display w)) (ev (x11-window-event-buffer w)))
      (let loop ((open #t))
        (if (zero? (XPending dpy))
            open
            (begin
              (XNextEvent dpy ev)
              (let ((type (ftype-ref x-any-event (type) (make-ftype-pointer x-any-event ev))))
                (cond
                 ((= type key-press)
                  (on-key (XLookupKeysym ev 0))
                  (loop open))
                 ((= type configure-notify)
                  (let* ((p (make-ftype-pointer x-configure-event ev))
                         (size (cons (ftype-ref x-configure-event (width) p)
                                     (ftype-ref x-configure-event (height) p))))
                    (unless (equal? size (x11-window-size w))
                      (x11-window-size-set! w size)
                      (on-resize (car size) (cdr size))))
                  (loop open))
                 ((= type client-message)
                  (let ((p (make-ftype-pointer x-client-message-event ev)))
                    (loop (and open
                               (not (= (ftype-ref x-client-message-event (data 0) p)
                                       (x11-window-wm-delete w)))))))
                 (else (loop open)))))))))
  )
