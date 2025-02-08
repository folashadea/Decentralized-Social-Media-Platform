;; Content Contract

(define-map posts
  { post-id: uint }
  {
    author: principal,
    content: (string-utf8 1000),
    created-at: uint,
    likes: uint
  }
)

(define-map user-posts
  { user-id: principal }
  (list 100 uint)
)

(define-data-var post-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))

(define-public (create-post (content (string-utf8 1000)))
  (let
    (
      (user tx-sender)
      (post-id (+ (var-get post-nonce) u1))
      (user-post-list (default-to (list) (map-get? user-posts { user-id: user })))
    )
    (map-set posts
      { post-id: post-id }
      {
        author: user,
        content: content,
        created-at: block-height,
        likes: u0
      }
    )
    (map-set user-posts
      { user-id: user }
      (unwrap! (as-max-len? (append user-post-list post-id) u100) ERR_UNAUTHORIZED)
    )
    (var-set post-nonce post-id)
    (ok post-id)
  )
)

(define-public (like-post (post-id uint))
  (let
    (
      (post (unwrap! (map-get? posts { post-id: post-id }) ERR_NOT_FOUND))
    )
    (map-set posts
      { post-id: post-id }
      (merge post { likes: (+ (get likes post) u1) })
    )
    (ok true)
  )
)

(define-read-only (get-post (post-id uint))
  (map-get? posts { post-id: post-id })
)

(define-read-only (get-user-posts (user principal))
  (map-get? user-posts { user-id: user })
)

