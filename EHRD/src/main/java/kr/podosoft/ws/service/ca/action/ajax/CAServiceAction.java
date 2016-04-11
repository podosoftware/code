package kr.podosoft.ws.service.ca.action.ajax;

import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaEducationService;
import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.ca.CAService;
import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.utils.CommonUtils;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;
//import pjt.dainlms.aria.CipherAria;


public class CAServiceAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 3979575171268570131L;

	private int pageSize = 15 ;
 
	private String sortField;
	
	private String sortDir;
	
	private Filter filter;
	    
    private int startIndex = 0 ;  
     
    private int totalItemCount = 0;
     
	private int year = 0;
	
	private int questionSaveCnt = 0;
	
	 private int saveCount = 0 ;  

	private List items;
	
	private List items1;
	
	private List items2;	
	
	private List<Map<String,Object>> items3;
	
	private CdpService cdpService;
	
	private List cmpScore;
	
	private List subjectList;
	
	private List notSubjectList;
	
	private List cmpResultList;
	
	private List cmpExplanation;
	
	private List subelementResultList;
	
	private List subelementExplanation;
	
	private String statement ; 
	
	private String successFlag ; 
	
	private CAService caService;
	
	private BaEducationService baEducationService;
	
	private Map question;
	
	private List examples;
	
	private List developmentGuide;
	
	private List subjectInfo;
	
	private List actList;

	private String diagResultString;

	private String diagResultScore;
	
	private int couponCount;
	
	private List linkageParam;
	
	private String brdInsertNum;
	
	
	
	public String getSortField() {
		return sortField;
	}

	public void setSortField(String sortField) {
		this.sortField = sortField;
	}

	public String getSortDir() {
		return sortDir;
	}

	public void setSortDir(String sortDir) {
		this.sortDir = sortDir;
	}

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
	}

	public List<Map<String, Object>> getItems3() {
		return items3;
	}

	public void setItems3(List<Map<String, Object>> items3) {
		this.items3 = items3;
	}

	public CdpService getCdpService() {
		return cdpService;
	}

	public void setCdpService(CdpService cdpService) {
		this.cdpService = cdpService;
	}

	public String getBrdInsertNum() {
		return brdInsertNum;
	}

	public void setBrdInsertNum(String brdInsertNum) {
		this.brdInsertNum = brdInsertNum;
	}

	public int getCouponCount() {
		return couponCount;
	}

	public void setCouponCount(int couponCount) {
		this.couponCount = couponCount;
	}

	public List getCmpResultList() {
		return cmpResultList;
	}

	public void setCmpResultList(List cmpResultList) {
		this.cmpResultList = cmpResultList;
	}

	public List getCmpExplanation() {
		return cmpExplanation;
	}

	public void setCmpExplanation(List cmpExplanation) {
		this.cmpExplanation = cmpExplanation;
	}

	public List getSubelementResultList() {
		return subelementResultList;
	}

	public void setSubelementResultList(List subelementResultList) {
		this.subelementResultList = subelementResultList;
	}

	public List getSubelementExplanation() {
		return subelementExplanation;
	}

	public void setSubelementExplanation(List subelementExplanation) {
		this.subelementExplanation = subelementExplanation;
	}

	public List getExamples() {
		return examples;
	}

	public void setExamples(List examples) {
		this.examples = examples;
	}

	public Map getQuestion() {
		return question;
	}

	public void setQuestion(Map question) {
		this.question = question;
	}

	public CAService getCaService() {
		return caService;
	}

	public void setCaService(CAService caService) {
		this.caService = caService;
	}

	public BaEducationService getBaEducationService() {
		return baEducationService;
	}

	public void setBaEducationService(BaEducationService baEducationService) {
		this.baEducationService = baEducationService;
	}

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

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}
		
	public int getTotalItemCount() {
		return totalItemCount;
	}
	

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}
	
	public int getQuestionSaveCnt() {
		return questionSaveCnt;
	}

	public void setQuestionSaveCnt(int questionSaveCnt) {
		this.questionSaveCnt = questionSaveCnt;
	}

	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	public String getStatement() {
		return statement;
	}


	public void setStatement(String statement) {
		this.statement = statement;
	}


	public List getItems() {
		return items;
	}


	public void setItems(List items) {
		this.items = items;
	}
	
	public List getItems1() {
		return items1;
	}

	public void setItems1(List items1) {
		this.items1 = items1;
	}
	
	public List getItems2() {
		return items2;
	}

	public void setItems2(List items2) {
		this.items2 = items2;
	}
	
	public List getCmpScore() {
		return cmpScore;
	}

	public void setCmpScore(List cmpScore) {
		this.cmpScore = cmpScore;
	}

	public List getSubjectList() {
		return subjectList;
	}

	public void setSubjectList(List subjectList) {
		this.subjectList = subjectList;
	}

	public List getNotSubjectList() {
		return notSubjectList;
	}

	public void setNotSubjectList(List notSubjectList) {
		this.notSubjectList = notSubjectList;
	}

	public List getDevelopmentGuide() {
		return developmentGuide;
	}

	public void setDevelopmentGuide(List developmentGuide) {
		this.developmentGuide = developmentGuide;
	}

	public String getDiagResultString() {
		return diagResultString;
	}

	public void setDiagResultString(String diagResultString) {
		this.diagResultString = diagResultString;
	}

	public String getDiagResultScore() {
		return diagResultScore;
	}

	public void setDiagResultScore(String diagResultScore) {
		this.diagResultScore = diagResultScore;
	}

	public List getSubjectInfo() {
		return subjectInfo;
	}

	public void setSubjectInfo(List subjectInfo) {
		this.subjectInfo = subjectInfo;
	}

	public List getActList() {
		return actList;
	}

	public void setActList(List actList) {
		this.actList = actList;
	}

	public List getLinkageParam() {
		return linkageParam;
	}

	public void setLinkageParam(List linkageParam) {
		this.linkageParam = linkageParam;
	}
	
	public String getSuccessFlag() {
		return successFlag;
	}

	public void setSuccessFlag(String successFlag) {
		this.successFlag = successFlag;
	}
	/**
	 * 
	 * 고객센터 메인<br/>
	 *
	 * @return
	 * @throws CAException 
	 * @since 2014. 4. 11.
	 */
	public String getCstmCntr() throws CAException{
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		//고객센터 02 사내 서비스 이용중 오류나 장애 응대자
		long userid2 = 1500;
		
		//고객센터 01 사내 역량 및 성과제도 응대자
		List list = caService.queryForList("CA.CSTM_CNTR",new Object[]{companyid, companyid, companyid, companyid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		//고객센터 02 사내 서비스 이용중 오류나 장애 응대자
		this.items2 = caService.queryForList("CA.CSTM_CNTR2",new Object[]{}, new int[]{});
		
		
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			String phone = "";
			String tmp = "";
			String eMail = "";
			String name ="";
			String dvsName ="";
			String ldrName = "";
			try {
				if(map.get("PHONE")!=null){
					phone = CommonUtils.ASEDecoding(map.get("PHONE").toString());
					
					tmp = phone;
					
					if(tmp.indexOf("02")>-1){
						phone = tmp.substring(0, 2)+")"+tmp.substring(2, tmp.length()-4)+"."+tmp.substring( tmp.length()-4);
					}else{
						phone = tmp.substring(0, 3)+")"+tmp.substring(3, tmp.length()-4)+"."+tmp.substring( tmp.length()-4);
					}
				}else{
					phone = "";
				}
				if(map.get("EMAIL")!=null){
					eMail = CommonUtils.ASEDecoding(map.get("EMAIL").toString());
				}else{
					eMail = "";
				}
				if(map.get("DVS_NAME")!=null){
					dvsName = map.get("DVS_NAME").toString();
				}else{
					dvsName = "";
				}
				if(map.get("NAME")!=null){
					name = map.get("NAME").toString();
				}else{
					name = "";
				}
				if(map.get("LEADERSHIP_NAME")!=null){
					ldrName = map.get("LEADERSHIP_NAME").toString();
				}else{
					ldrName = "";
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			map.put("PHONE", phone);
			map.put("EMAIL", eMail);
			map.put("NAME", name);
			map.put("DVS_NAME", dvsName);
			map.put("LEADERSHIP_NAME", ldrName);
			this.items = new ArrayList();
			this.items.add(map);
		}
		
		
		if(items2!=null && items2.size()>0){
			Map map2 = (Map)items2.get(0);
			String phone2 = "";
			String tmp = "";
			String eMail2 = "";
			String name2 ="";
			String dvsName2 ="";
			String ldrName2 = "";
			try {
				if(map2.get("PHONE")!=null){
					phone2 = CommonUtils.ASEDecoding(map2.get("PHONE").toString());
					
					tmp = phone2;
					
					if(tmp.indexOf("02")>-1){
						phone2 = tmp.substring(0, 2)+")"+tmp.substring(2, tmp.length()-4)+"."+tmp.substring( tmp.length()-4);
					}else{
						phone2 = tmp.substring(0, 3)+")"+tmp.substring(3, tmp.length()-4)+"."+tmp.substring( tmp.length()-4);
					}
					
				}else{
					phone2 = "";
				}
				if(map2.get("EMAIL")!=null){
					eMail2 = CommonUtils.ASEDecoding(map2.get("EMAIL").toString());
				}else{
					eMail2 = "";
				}
				if(map2.get("DVS_NAME")!=null){
					dvsName2 = map2.get("DVS_NAME").toString();
				}else{
					dvsName2 = "";
				}
				if(map2.get("NAME")!=null){
					name2 = map2.get("NAME").toString();
				}else{
					name2 = "";
				}
				if(map2.get("LEADERSHIP_NAME")!=null){
					ldrName2 = map2.get("LEADERSHIP_NAME").toString();
				}else{
					ldrName2 = "";
				}
				
				
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			map2.put("PHONE2", phone2);
			map2.put("EMAIL2", eMail2);
			map2.put("NAME2", name2);
			map2.put("DVS_NAME2", dvsName2);
			map2.put("LEADERSHIP_NAME2", ldrName2);
			this.items2 = new ArrayList();
			this.items2.add(map2);
		}
		return success();
	}
			
	/**
	 * 
	 * 게시판 - 공지사항<br/>
	 *
	 * @return
	 * @since 2014. 11. 10.
	 */
	public String getBrdNoticeMain(){
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		request.setAttribute("BOARD_CODE", "1");
		
		return success();
	}
	
	/**
	 * 
	 * 게시판 - 질문과답변<br/>
	 *
	 * @return
	 * @since 2014. 11. 10.
	 */
	public String getBrdQnaMain(){
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		request.setAttribute("BOARD_CODE", "2");
		
		return success();
	}
	
	/**
	 * 
	 * 게시판 - 교육안내<br/>
	 *
	 * @return
	 * @since 2014. 11. 10.
	 */
	public String getBrdEduInfoMain(){
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		request.setAttribute("BOARD_CODE", "3");
		
		return success();
	}

	/**
	 * 
	 * 게시판 조회<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String getBrdList() throws Exception{
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		String brdCd = ParamUtils.getParameter(request, "BRD_CD");
		
		
		/*this.items = caService.queryForList("CA.GET_BRD_LIST",new Object[]{companyId,brdCd}, new int[]{Types.NUMERIC,Types.VARCHAR});
		this.totalItemCount = items.size();*/
		
		
		Map map =  new HashMap();

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items3 = cdpService.dynamicQueryForList("CA.GET_BRD_LIST", startIndex, pageSize, sortField, sortDir, "ROWNUMBER DESC", filter, new Object[]{ companyId, brdCd }, new int[]{ Types.NUMERIC, Types.NUMERIC }, map);
		
		if(this.items3 !=null && this.items3.size()>0){
			this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}
	
	/**
	 * 
	 * 게시판 코멘트<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String getBrdComent() throws CAException{
		
		long companyId = getUser().getCompanyId();
		String brdCd = ParamUtils.getParameter(request, "BRD_CD");
		String brdNum = ParamUtils.getParameter(request, "BOARD_NUM");
		
		this.items = caService.queryForList("CA.GET_BRD_COMENT_LIST",new Object[]{brdCd, brdNum, companyId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 게시판 저장,수정<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String brdContSave() throws CAException{
		
		String brdtitle = ParamUtils.getParameter(request, "BOARD_TITLE");
		String brdcont = ParamUtils.getParameter(request, "BOARD_CONTENT");
		String brdCd = ParamUtils.getParameter(request, "BOARD_CODE");
		String brdNum = ParamUtils.getParameter(request, "BOARD_NUM");
		List<Map<String, Object>> mailList = ParamUtils.getJsonParameter(request, "mailItem", "LIST",List.class);
		
		/*if(brdNum == null || brdNum.equals("")){ // 등록일 경우 시퀀스를 받아온다.
			brdNum = caService.seqBrdNum(); 
		}*/
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
	
		this.saveCount = caService.brdContSave(brdtitle, brdcont, brdCd, brdNum, brdCd, userId, companyId, mailList); 
		return success();
	}
	
	
	/**
	 * 
	 * 게시판 게시글 삭제<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String getBrdDel() throws CAException{
		
		String repNum = ParamUtils.getParameter(request, "REPLY_NUM");
		String brdCd = ParamUtils.getParameter(request, "BRD_CD");
		String brdNum = ParamUtils.getParameter(request, "BOARD_NUM");
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		
		//게시글삭제
		this.saveCount += caService.update("CA.GET_BRD_DEL",new Object[]{userId, companyId, brdCd, brdNum}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR,Types.NUMERIC });
		//게시글에 해당하는 코멘트 삭제 
		this.saveCount += caService.update("CA.GET_BRD_COMENT_ALL_DEL", new Object[]{userId, companyId, brdCd, brdNum}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC});
		return success();
	}
	
	
	/**
	 * 
	 * 게시판 코멘트 저장<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String getBrdComentSave() throws CAException{
		
		String brdcont = ParamUtils.getParameter(request, "REPLY_CONTENT");
		String brdCd = ParamUtils.getParameter(request, "BRD_CD");
		String brdNum = ParamUtils.getParameter(request, "BOARD_NUM");
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
	
		String maxCnt = caService.comentMaxCnt(brdCd, brdNum, getUser());
		
		this.saveCount = caService.brdComentSave(brdCd, brdNum, maxCnt, brdcont, userId, companyId);
		return success();
	}
	
	/**
	 * 
	 * 게시판 코멘트 삭제<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String getBrdComentDel() throws CAException{
		
		String repNum = ParamUtils.getParameter(request, "REPLY_NUM");
		String brdCd = ParamUtils.getParameter(request, "BRD_CD");
		String brdNum = ParamUtils.getParameter(request, "BOARD_NUM");
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
	
		this.saveCount = caService.update("CA.GET_BRD_COMENT_DEL", new Object[]{userId, brdCd, brdNum, repNum, companyId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC});
		return success();
	}
	
	/**
	 * 
	 * 게시판 상세화면<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String getBrdDetail() throws CAException{
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		
		String brdCd = ParamUtils.getParameter(request, "BOARD_CODE");
		String brdNum = ParamUtils.getParameter(request, "BOARD_NUM");
		String brdType = ParamUtils.getParameter(request, "BOARD_TYPE");
		request.setAttribute("BOARD_TYPE", brdType );
		
		caService.update("CA.GET_BRD_UP_COUNT", new Object[]{companyId, brdCd, brdNum, companyId, brdCd, brdNum}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.items = caService.queryForList("CA.GET_BRD_DETAIL_LIST",new Object[]{brdCd, brdNum, companyId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		return success();
	}
	
	/**
	 * 
	 * 게시판 등록/수정화면<br/>
	 *
	 * @return
	 * @since 2014. 11. 11.
	 */
	public String getBrdUpdate() throws CAException{
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		
		this.brdInsertNum = caService.seqBrdNum(); 
		
		String brdCd = ParamUtils.getParameter(request, "BOARD_CODE");
		String brdNum = ParamUtils.getParameter(request, "BOARD_NUM");
		
		if(brdNum != null){
			this.items = caService.queryForList("CA.GET_BRD_DETAIL_LIST",new Object[]{brdCd, brdNum, companyId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		}
		return success();
	}
	
	/**
	 * 
	 * 핵심역량교육실적관리 조회<br/>
	 *
	 * @return
	 * @since 2014. 12. 01.
	 */
	public String getCoreCmptEduMngList() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyId = getUser().getCompanyId();

		Map map =  new HashMap();

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items3 = cdpService.dynamicQueryForList("CA.CORE_CMPT_EDU_MNG_LIST", startIndex, pageSize, sortField, sortDir, "ROWNUMBER", filter, new Object[]{ companyId }, new int[]{ Types.NUMERIC }, map);
		
		if(this.items3 !=null && this.items3.size()>0){
			this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}

	
	/**
	 * 
	 * 핵심역량교육실적관리 저장<br/>
	 *
	 * @return
	 * @since 2014. 12. 02.
	 */
	public String saveCmptEduMng() throws CAException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String eduPrfSeq = ParamUtils.getParameter(request, "MJR_CMPT_EDU_PRF_SEQ");
		String userId = ParamUtils.getParameter(request, "USERID");
		String division = ParamUtils.getParameter(request, "DIVISIONID");
		String gradeNum = ParamUtils.getParameter(request, "GRADE_NM");
		String evlRst = ParamUtils.getParameter(request, "EVL_RST");
		String evlSco = ParamUtils.getParameter(request, "EVL_SCO");
		String evlDt = ParamUtils.getParameter(request, "EVL_DT");
		String evlStDt = ParamUtils.getParameter(request, "EVL_ST_DT");
		String evlEdDt = ParamUtils.getParameter(request, "EVL_ED_DT");
		String evlNm = ParamUtils.getParameter(request, "EVL_NM");
		
		long exCompanyId = getUser().getCompanyId();
		long exUserId = getUser().getUserId();
		
		this.saveCount =caService.update("CA.SAVE_CMPT_EDU_MNG", new Object[]{eduPrfSeq, exCompanyId, userId, division, gradeNum, evlRst, evlSco, evlDt, evlStDt, evlEdDt, exUserId, evlNm  }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.NUMERIC,Types.VARCHAR});
		
		return success();
	}
	
	/**
	 * 
	 * 핵심역량교육실적관리 삭제<br/>
	 *
	 * @return
	 * @since 2014. 12. 02.
	 */
	public String deleteCmptEduMng() throws CAException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String eduPrfSeq = ParamUtils.getParameter(request, "MJR_CMPT_EDU_PRF_SEQ");
		
		long exCompanyId = getUser().getCompanyId();
		long exUserId = getUser().getUserId();
		
		if(eduPrfSeq != null && !"".equals(eduPrfSeq)){
			this.saveCount =caService.update("CA.DELETE_CMPT_EDU_MNG", new Object[]{exUserId, eduPrfSeq, exCompanyId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		}
		return success();
	}
	
	
}