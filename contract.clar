;; Study Timers: Track focused work sessions

(define-map study-sessions principal uint)
(define-data-var total-time-logged uint u0)

(define-constant err-invalid-duration (err u100))

;; Log a study session in minutes
(define-public (log-session (duration uint))
  (begin
    (asserts! (> duration u0) err-invalid-duration)
    (map-set study-sessions tx-sender
             (+ (default-to u0 (map-get? study-sessions tx-sender)) duration))
    (var-set total-time-logged (+ (var-get total-time-logged) duration))
    (ok true)))

;; Get total time studied by the sender
(define-read-only (get-my-study-time)
  (ok (default-to u0 (map-get? study-sessions tx-sender))))
