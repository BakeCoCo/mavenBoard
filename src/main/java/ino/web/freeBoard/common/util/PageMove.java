package ino.web.freeBoard.common.util;

public class PageMove {
	
	public static int pageSize = 10;
	public static int totalCount = 0;		// 전체 리스트수
	public static int totalPage = 0;			// 전체 페이지수
	public static int currentPage = 1;		// 현재 페이지
	public static int startNo = 0;			// 시작 숫자
	public static int endNo = 0;				// 끝 숫자
	public static int startPage = 0;			// 시작 페이지
	public static int endPage = 0;			// 끝 페이지
	
	public void FBoardPage(int totalCount, int pageSize, int currentPage) {
		this.pageSize = pageSize;
		this.totalCount = totalCount;
		this.currentPage = currentPage;
		calculator();
	}
	
	private void calculator() {
		totalPage = (totalCount - 1) / pageSize + 1;
		currentPage = currentPage > totalPage ? totalPage : currentPage;
		startNo = (currentPage - 1) * pageSize + 1;
		endNo = startNo + pageSize - 1;
		endNo = endNo > totalCount ? totalCount : endNo;
		startPage = (currentPage - 1) / 10 * 10 + 1;
		endPage = startPage + 9;
		endPage = endPage > totalPage ? totalPage : endPage;
	}
	
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getStartNo() {
		return startNo;
	}
	public void setStartNo(int startNo) {
		this.startNo = startNo;
	}
	public int getEndNo() {
		return endNo;
	}
	public void setEndNo(int endNo) {
		this.endNo = endNo;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	
	
	@Override
	public String toString() {
		return "PageMove [totalCount=" + totalCount + ", totalPage=" + totalPage + ", currentPage=" + currentPage
				+ ", startNo=" + startNo + ", endNo=" + endNo + ", startPage=" + startPage + ", endPage=" + endPage
				+ "]";
	}
	
	
	
}
