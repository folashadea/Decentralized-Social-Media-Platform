;; User Profile Contract

(define-map profiles
  { user-id: principal }
  {
    username: (string-ascii 30),
    bio: (string-utf8 280),
    avatar: (optional (string-ascii 256)),
    created-at: uint
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_ALREADY_EXISTS (err u409))

(define-public (create-profile (username (string-ascii 30)) (bio (string-utf8 280)))
  (let
    (
      (user tx-sender)
    )
    (asserts! (is-none (map-get? profiles { user-id: user })) ERR_ALREADY_EXISTS)
    (map-set profiles
      { user-id: user }
      {
        username: username,
        bio: bio,
        avatar: none,
        created-at: block-height
      }
    )
    (ok true)
  )
)

(define-public (update-profile (bio (string-utf8 280)) (avatar (optional (string-ascii 256))))
  (let
    (
      (user tx-sender)
      (existing-profile (unwrap! (map-get? profiles { user-id: user }) ERR_NOT_FOUND))
    )
    (map-set profiles
      { user-id: user }
      (merge existing-profile
        {
          bio: bio,
          avatar: avatar
        }
      )
    )
    (ok true)
  )
)

(define-read-only (get-profile (user principal))
  (map-get? profiles { user-id: user })
)

