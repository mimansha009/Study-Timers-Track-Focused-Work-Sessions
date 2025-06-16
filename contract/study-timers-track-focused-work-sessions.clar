(define-map study-sessions
  principal
  { start-time: uint, total-time: uint })

;; Start a study session
(define-public (start-session)
  (let ((current (map-get? study-sessions tx-sender)))
    (match current session
      (begin
        ;; Prevent overwriting if already studying
        (asserts! (= (get start-time session) u0) (err u101))
        (map-set study-sessions tx-sender
                 { start-time: block-height, total-time: (get total-time session) })
        (ok true))
      (begin
        ;; First time starting session
        (map-set study-sessions tx-sender
                 { start-time: block-height, total-time: u0 })
        (ok true)))))

;; End a study session
(define-public (end-session)
  (let ((session (map-get? study-sessions tx-sender)))
    (match session data
      (begin
        (asserts! (> (get start-time data) u0) (err u102))
        (let ((duration (- block-height (get start-time data))))
          (map-set study-sessions tx-sender
                   { start-time: u0, total-time: (+ (get total-time data) duration) })
          (ok duration)))
      (err u103))))
