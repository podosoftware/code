/**
 * 사용자화면
 * 커뮤니티
 */
package kr.podosoft.ws.service.brd.action.ajax;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.brd.BRDService;

import architecture.ee.web.attachment.FileInfo;
import architecture.ee.web.struts2.action.UploadAttachmentAction;
import architecture.ee.web.util.ParamUtils;


public class BRDServiceAction extends UploadAttachmentAction  {

	private static final long serialVersionUID = 9059010169809270465L;
	
	private int pageSize = 15;
    private int startIndex = 0;
    
    private int totalItemCount;
    private List items;
    private List cmpList;
    private int saveCount;
    
    private List fileList;
    private List selectCmpList;

    private BRDService brdService;
	
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getStartIndex() {
		return startIndex;
	}
	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	public int getTotalItemCount() {
		return totalItemCount;
	}
	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	public List getItems() {
		return items;
	}
	public void setItems(List items) {
		this.items = items;
	}

	public int getSaveCount() {
		return saveCount;
	}
	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	public BRDService getBrdService() {
		return brdService;
	}
	public void setBrdService(BRDService brdService) {
		this.brdService = brdService;
	}


	public List getCmpList() {
		return cmpList;
	}
	public void setCmpList(List cmpList) {
		this.cmpList = cmpList;
	}
	
	public List getFileList() {
		return fileList;
	}
	public void setFileList(List fileList) {
		this.fileList = fileList;
	}
	public List getSelectCmpList() {
		return selectCmpList;
	}
	public void setSelectCmpList(List selectCmpList) {
		this.selectCmpList = selectCmpList;
	}
	/**
	 * 커뮤니티 글목록 제공
	 * @return
	 */
	public String getBoardList() {
		
//		게시판번호
//		1. 커뮤니티_New&Notice
//		2. 커뮤니티_묻고답하기
//		3. 커뮤니티_자주하는질문
//		4. 취업관련정보_채용정보
//		5. 취업관련정보_아르바이트
//		6. 취업관련정보_공모전정보
//		7. 취업관련정보_대내활동정보
//		8. 취업관련정보_대외활동정보
//		9. 교수학습센터_자료실
		
		String boardCode = ParamUtils.getParameter(request, "BOARD_CODE");
		
		items = brdService.getBoardList(boardCode, getUser().getUserId());
		
		this.cmpList = brdService.competencyList(getUser());
		
		totalItemCount = items.size();
		
		return success();
	}
	
	/**
	 * 커뮤니티 글상세보기
	 * @return
	 */
	public String getBoardDetail() {
		

		String boardCode = ParamUtils.getParameter(request, "BOARD_CODE");
		String boardNum = ParamUtils.getParameter(request, "BOARD_NUM");
		
		items = brdService.getBoardDetail(boardCode, boardNum, getUser().getUserId());
		fileList  = brdService.getBoardDetailFileList(boardCode, boardNum);
		selectCmpList= brdService.getBoardDetailCmpList(getUser().getCompanyId(), boardCode, boardNum);

		return success();
	}

	
	public String boardCreate() {
		
		String boardCode 		= ParamUtils.getParameter(request, "BOARD_CODE");
		String boardTittle 	 	= ParamUtils.getParameter(request, "BOARD_TITTLE");
		String boardContent 	= ParamUtils.getParameter(request, "BOARD_CONTENT");
		String actSdate 			= ParamUtils.getParameter(request, "ACT_SDATE");
		String actEdate 			= ParamUtils.getParameter(request, "ACT_EDATE");
		String noticeFlag 		= ParamUtils.getParameter(request, "NOTICE_FLAG");
		List<Map<String, Object>> cmpList 	= ParamUtils.getJsonParameter(request, "jsonData","CMP_LIST", List.class);

		List<FileInfo> list = getAttachmentFileInfos();

		this.saveCount = brdService.saveBoard(boardCode, boardTittle, boardContent, actSdate, actEdate, noticeFlag,  list, getUser(), cmpList);

		return success();
	}
	
	public String boardReplyCreate() {
		
		String boardCode 		= ParamUtils.getParameter(request, "BOARD_CODE");
		String upBoardNum 	= ParamUtils.getParameter(request, "BOARD_NUM");
		String boardTittle 	 	= ParamUtils.getParameter(request, "BOARD_TITTLE");
		String boardContent 	= ParamUtils.getParameter(request, "BOARD_CONTENT");
		
		List<FileInfo> list = getAttachmentFileInfos();
		
		this.saveCount = brdService.boardReplyCreate(boardCode, upBoardNum, boardTittle, boardContent, list, getUser());
		
		return success();
	}
	
	public String boardUpdate(){
		
		String boardCode 		= ParamUtils.getParameter(request, "BOARD_CODE");
		String boardNum 		= ParamUtils.getParameter(request, "BOARD_NUM");
		String boardTittle 	 	= ParamUtils.getParameter(request, "BOARD_TITTLE");
		String boardContent 	= ParamUtils.getParameter(request, "BOARD_CONTENT");
		String actSdate 			= ParamUtils.getParameter(request, "ACT_SDATE");
		String actEdate 			= ParamUtils.getParameter(request, "ACT_EDATE");
		String noticeFlag 		= ParamUtils.getParameter(request, "NOTICE_FLAG");
		List<Map<String, Object>> cmpList 	= ParamUtils.getJsonParameter(request, "jsonData","CMP_LIST", List.class);
		
		List<FileInfo> list = getAttachmentFileInfos();
		
		this.saveCount = brdService.updateBoard(boardCode, boardNum,  boardTittle, boardContent, actSdate, actEdate,  list, getUser(), noticeFlag, cmpList);
		
		return success();
	}
	
	public String boardDelete(){
		
		String boardCode 		= ParamUtils.getParameter(request, "BOARD_CODE");
		String boardNum 		= ParamUtils.getParameter(request, "BOARD_NUM");
	
		
		List<FileInfo> list = getAttachmentFileInfos();
		
		this.saveCount = brdService.boardDelete(boardCode, boardNum, getUser().getCompanyId());  
		
		return success();
	}
	
	/**
	 * 
	 * 파일업로드 <br/>
	 *
	 * @return
	 * @since 2014. 4. 4.
	 */
	public String fileUpload() {
		List<FileInfo> list = getAttachmentFileInfos();
		this.saveCount = (int) brdService.fileUpload(getUser(), list);
		return success();
	}
	
}