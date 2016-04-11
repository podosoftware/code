/**
 * 관리자화면
 * 커뮤니티
 */
package kr.podosoft.ws.service.brd.action.admin;

import java.io.InputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.brd.BRDService;

import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;


public class BRDMgmtAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 4479786867994147255L;
	
	private int pageSize = 15 ;
    private int startIndex = 0 ;  
    
    private int totalItemCount = 0;
    private List items;
    private int saveCount = 0;
	
	private String targetAttachmentContentType = "";
	private String targetAttachmentContentLength = "";
	private InputStream targetAttachmentInputStream = null;
	private String targetAttachmentFileName = "";

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

	public String getTargetAttachmentContentType() {
		return targetAttachmentContentType;
	}

	public void setTargetAttachmentContentType(String targetAttachmentContentType) {
		this.targetAttachmentContentType = targetAttachmentContentType;
	}

	public String getTargetAttachmentContentLength() {
		return targetAttachmentContentLength;
	}

	public void setTargetAttachmentContentLength(
			String targetAttachmentContentLength) {
		this.targetAttachmentContentLength = targetAttachmentContentLength;
	}

	public InputStream getTargetAttachmentInputStream() {
		return targetAttachmentInputStream;
	}

	public void setTargetAttachmentInputStream(
			InputStream targetAttachmentInputStream) {
		this.targetAttachmentInputStream = targetAttachmentInputStream;
	}

	public BRDService getBrdService() {
		return brdService;
	}

	public void setBrdService(BRDService brdService) {
		this.brdService = brdService;
	}

	public String getTargetAttachmentFileName() {
		try{
			targetAttachmentFileName = URLEncoder.encode(targetAttachmentFileName, "UTF-8");
		}catch(Exception e){
			log.error(e);
		}
		return targetAttachmentFileName;
	}

	public void setTargetAttachmentFileName(String targetAttachmentFileName) {
		this.targetAttachmentFileName = targetAttachmentFileName;
	}

	public String getCommunityList(){
		
		//this.items = brdService.getCommunityListServie(startIndex, pageSize, getUser().getCompanyId(), year);
		
		//this.totalItemCount = brdService.getCommunityListCount(getUser().getCompanyId(), year);
		return success();
	}
	
//	public String getCommunityFileList(){
//		
//		String fileNum = ParamUtils.getParameter(request, "FILE_NUM");
//		
//		this.items = brdService.getCommunityFileListService(fileNum);
//		return success();
//	}
	
	public String fileDownLoad(){
		
		int fileNum  = ParamUtils.getIntParameter(request, "FILE_NUM", 0);
		int seqNum = ParamUtils.getIntParameter(request, "SEQ_NUM", 0);
		
		Map map = brdService.fileDownloadInfo(fileNum, seqNum);
		
		this.targetAttachmentContentType = (String)map.get("contentType");
		this.targetAttachmentContentLength = (String)map.get("contentLength");
		this.targetAttachmentInputStream = (InputStream)map.get("is");
		this.targetAttachmentFileName = (String)map.get("fileName");
		
		log.debug("targetAttachmentContentType : " + this.targetAttachmentContentType);
		log.debug("targetAttachmentContentLength : " + this.targetAttachmentContentLength);
		log.debug("targetAttachmentInputStream : " + this.targetAttachmentInputStream);
		log.debug("targetAttachmentFileName : " + this.targetAttachmentFileName);
		
		return success();
	}
	
	public String imageFileView(){
		
		int fileNum  = ParamUtils.getIntParameter(request, "FILE_NUM", 0);
		int seqNum = ParamUtils.getIntParameter(request, "SEQ_NUM", 0);
		
		Map map = brdService.fileDownloadInfo(fileNum, seqNum);
		
		this.targetAttachmentContentType = (String)map.get("contentType");
		this.targetAttachmentContentLength = (String)map.get("contentLength");
		this.targetAttachmentInputStream = (InputStream)map.get("is");
		this.targetAttachmentFileName = (String)map.get("fileName");
		
		log.debug("targetAttachmentContentType : " + this.targetAttachmentContentType);
		log.debug("targetAttachmentContentLength : " + this.targetAttachmentContentLength);
		log.debug("targetAttachmentInputStream : " + this.targetAttachmentInputStream);
		log.debug("targetAttachmentFileName : " + this.targetAttachmentFileName);
		
		return success();
	}
	
	public String fileDelete(){
		
		int fileNum  = ParamUtils.getIntParameter(request, "FILE_NUM", 0);
		int seqNum = ParamUtils.getIntParameter(request, "SEQ_NUM", 0);
		
		this.saveCount  = brdService.fileDelete(fileNum, seqNum);
		
		return success();
	}

}