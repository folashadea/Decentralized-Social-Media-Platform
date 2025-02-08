;; Moderation Contract

(define-map reported-posts
  { post-id: uint }
  {
    reporter: principal,
    reason: (string-utf8 280),
    status: (string-ascii 20),
    votes: int
  }
)

(define-map moderator-votes
  { post-id: uint, moderator: principal }
  { vote: int }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_ALREADY_REPORTED (err u409))

(define-public (report-post (post-id uint) (reason (string-utf8 280)))
  (let
    (
      (reporter tx-sender)
    )
    (asserts! (is-none (map-get? reported-posts { post-id: post-id })) ERR_ALREADY_REPORTED)
    (map-set reported-posts
      { post-id: post-id }
      {
        reporter: reporter,
        reason: reason,
        status: "pending",
        votes: 0
      }
    )
    (ok true)
  )
)

(define-public (vote-on-report (post-id uint) (vote int))
  (let
    (
      (moderator tx-sender)
      (report (unwrap! (map-get? reported-posts { post-id: post-id }) ERR_NOT_FOUND))
      (previous-vote (default-to { vote: 0 } (map-get? moderator-votes { post-id: post-id, moderator: moderator })))
    )
    (asserts! (or (is-eq vote 1) (is-eq vote -1)) ERR_UNAUTHORIZED)
    (map-set moderator-votes
      { post-id: post-id, moderator: moderator }
      { vote: vote }
    )
    (map-set reported-posts
      { post-id: post-id }
      (merge report { votes: (+ (get votes report) (- vote (get vote previous-vote))) })
    )
    (ok true)
  )
)

(define-read-only (get-report (post-id uint))
  (map-get? reported-posts { post-id: post-id })
)

