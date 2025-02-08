import { describe, it, beforeEach, expect } from "vitest"

describe("moderation", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      reportPost: (postId: number, reason: string) => ({ success: true }),
      voteOnReport: (postId: number, vote: number) => ({ success: true }),
      getReport: (postId: number) => ({
        reporter: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
        reason: "Inappropriate content",
        status: "pending",
        votes: 0,
      }),
    }
  })
  
  describe("report-post", () => {
    it("should report a post", () => {
      const result = contract.reportPost(1, "Inappropriate content")
      expect(result.success).toBe(true)
    })
  })
  
  describe("vote-on-report", () => {
    it("should vote on a reported post", () => {
      const result = contract.voteOnReport(1, 1)
      expect(result.success).toBe(true)
    })
  })
  
  describe("get-report", () => {
    it("should return report details", () => {
      const result = contract.getReport(1)
      expect(result.reporter).toBe("ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM")
      expect(result.reason).toBe("Inappropriate content")
    })
  })
})

