package kr.podosoft.ws.service.cam.action;

import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ca.CAService;
import kr.podosoft.ws.service.cam.CAMException;
import kr.podosoft.ws.service.cam.CAMService;
import kr.podosoft.ws.service.utils.CommonUtils;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;


public class CAMServiceAction extends FrameworkActionSupport {


	private static final long serialVersionUID = -2316562034839240657L;

	private int pageSize = 15 ;
	
    private int startIndex = 0 ;  
     
    private int totalItemCount = 0;
     
	private int year = 0;
	
	private int saveCount = 0 ;  
	 
	private int runNum = 0;

	private List items;
	
	private List items1;
	
	private List items2;	
	
	private String statement ;

	private CAMService camService;

	private CAService caService;
	
	
	public CAService getCaService() {
		return caService;
	}

	public void setCaService(CAService caService) {
		this.caService = caService;
	}

	public int getRunNum() {
		return runNum;
	}

	public void setRunNum(int runNum) {
		this.runNum = runNum;
	}

	public CAMService getCamService() {
		return camService;
	}

	public void setCamService(CAMService camService) {
		this.camService = camService;
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

	public int getTotalItemCount() {
		return totalItemCount;
	}

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
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

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	} 
	
	

	/*
	 * 2014  Project 역량진단 class
	 */

	/**
	 * 
	 * 역량진단 ( 일반사용자) 진단 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCmptEvlRunPg(){
		return success();
	}
	
	/**
	 * 
	 * 역량진단 ( 일반사용자) 진단 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCmptEvlRunList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getUserId(),
				getUser().getUserId(),
				getUser().getUserId(),
				getUser().getUserId(),
				getUser().getCompanyId(),
				getUser().getUserId(),
				getUser().getUserId(), 
				getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_EVL_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}
	
	

	/**
	 * 
	 * 역량진단 1단계 기본정보확인 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
	public String getCmptEvlBasicInfo() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		return success();
	}

	/**
	 * 
	 * 역량진단 - 진단기본정보 조회 <br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptRunInfoExe() throws CAMException{
		log.debug(CommonUtils.printParameter(request));

		Object [] params = {
				getUser().getCompanyId(), Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"))
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.CMPT_ANALY_RUN_INFO_EXE", params, jdbcTypes);
		return success();
	}
	
	/**
	 * 
	 * 역량진단 - 진단기본정보 조회 결과<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptRunInfo() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		Object [] params = {
				getUser().getCompanyId(), Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM")), Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"))
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.CMPT_ANALY_RUN_INFO", params, jdbcTypes);
		return success();
	}

	/**
	 * 
	 * 역량진단 피진단자 정보 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlUserExedInfo() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		//피진단자정보 조회
		this.items1 = camService.queryForList("EVL.GET_USER_EXED_INFO", new Object[]{tguserid}, new int[]{Types.NUMERIC});
		return success();
	}

	/**
	 * 
	 *  역량진단 진단별 피진단자 목록 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 17.
	 */
	public String getCmptEvlExedList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM").toString());
		long companyid = getUser().getCompanyId();
		long exUserid = getUser().getUserId();
		
		Object [] params = {
				companyid, runNum, exUserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_MSD_EXED_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 역량진단 2단계 다면진단 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
	public String getCmptEvlMsdExec() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		return success();
	}

	/**
	 * 
	 *  역량진단 - 다면진단 피평가자 문항 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 17.
	 */
	public String getCmptEvlMsdBhvList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM").toString());
		long companyid = getUser().getCompanyId();
		long exUserid = getUser().getUserId();
		
		Object [] params = {
				companyid, runNum, companyid, 
				companyid, runNum, companyid, runNum, exUserid, 
				companyid, runNum, companyid, runNum, exUserid, 
				companyid, runNum, exUserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_USER_MSD_EXED_BHV_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}

	/**
	 * 
	 *  역량진단 - 다면진단 피평가자 문항 응답정보 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 17.
	 */
	public String getCmptEvlMsdBhvResponseList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM").toString());
		long companyid = getUser().getCompanyId();
		long exUserid = getUser().getUserId();
		
		Object [] params = {
				companyid, runNum, companyid, companyid, runNum, exUserid, 
				companyid, runNum, companyid, runNum, exUserid, 
				companyid, runNum, companyid, runNum, exUserid, 
				companyid, runNum, exUserid, 
				companyid, runNum, exUserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_USER_MSD_EXED_BHV_RESPONSE_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		
		//진단 시작 시간 업데이트
		camService.update("EVL.START_EVL_TB_CAM_RUNDIRECTION_I", new Object[]{companyid, runNum, exUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		
		return success();
	}

	/**
	 * 
	 * 역량진단 결과 저장.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
	public String cmptEvlSave() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = camService.cmptEvlSave(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 역량진단 당시 정보 조회...<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 10. 17.
	 */
	public String getAnalysisCmpt() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		this.items = camService.queryForList("EVL.CMPT_ANALY_RUN_INFO", new Object[]{getUser().getCompanyId(), Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM")), getUser().getUserId()}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} );
		if(this.items!=null && this.items.size()>0){
			Map map = (Map)this.items.get(0);
			
			request.setAttribute("JOB", map.get("JOB"));
			request.setAttribute("LEADERSHIP", map.get("LEADERSHIP"));
		}
		return success();
	}

	/**
	 * 
	 * 역량진단 자가진단 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
	public String getCmptEvlSelfExec() throws CAMException{
		log.debug(CommonUtils.printParameter(request));

		this.items = caService.getCommonCodeListService( "C115", getUser().getCompanyId(), null);
		
		return success();
	}
	
	/**
	 * 
	 * 역량진단 자가진단 문항 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
public String getCmptEvlSelfExecBhvList() throws CAMException{
		
		long companyid = getUser().getCompanyId();
		long execUserid = getUser().getUserId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		int tgUserid = Integer.parseInt(ParamUtils.getParameter(request, "TG_USERID", "0"));

		//평가문항 조회
		Object [] params1 = {
				tgUserid, companyid, runNum, companyid, 
				companyid, runNum,companyid, runNum, execUserid, tgUserid,  
				companyid, runNum,companyid, runNum, execUserid, tgUserid,  
				companyid,runNum, execUserid, tgUserid
		};
		int[] jdbcTypes1 = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_EVL_SELF_EXEC_BHV", params1, jdbcTypes1);
		this.totalItemCount = items.size();
		
		//평가 시작 시간 업데이트
		camService.update("EVL.START_EVL_TB_CAM_RUNDIRECTION_I", new Object[]{ companyid, runNum, execUserid }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 
	 * 부서원역량진단진단 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getDeptMgrCmptEvlRunList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), getUser().getUserId(), getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_DEPTMGR_RUN_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 *  부서원역량진단 진단별 피진단자 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 17.
	 */
	public String getDeptMgrCmptEvlExedPg() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM").toString());

		Object [] params = {
				getUser().getCompanyId(), getUser().getUserId(), getUser().getCompanyId(), runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_DEPTMGR_RUN_INFO", params, jdbcTypes);
		List list = camService.queryForList("EVL.GET_COMPANY_OPERATOR_USER_INFO", new Object[]{getUser().getCompanyId(),}, new int[]{Types.NUMERIC});
		
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			String decPhone = "";
			try {
				if(map.get("PHONE")!=null){
					decPhone = CommonUtils.ASEDecoding(map.get("PHONE").toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			map.put("DEC_PHONE", decPhone);
			this.items1 = new ArrayList();
			this.items1.add(map);
		}
		return success();
	}
	

	/**
	 * 
	 *  부서원역량진단 진단별 진단자 정보조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 17.
	 */
	public String getDeptMgrCmptEvlExecUserList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM").toString());
		int tgUserid = Integer.parseInt(ParamUtils.getParameter(request, "TG_USERID", "0"));
		long companyid = getUser().getCompanyId();
		
		Object [] params = {
				companyid, runNum, tgUserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_DEPTMGR_EXEC_USER_LIST", params, jdbcTypes);
		return success();
	}
	
	
	/**
	 * 
	 *  부서원역량진단 진단별 피진단자 목록 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 17.
	 */
	public String getDeptMgrCmptEvlExedList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM").toString());
		long companyid = getUser().getCompanyId();
		long exUserid = getUser().getUserId();
		
		Object [] params = {
				companyid, runNum, exUserid, companyid, runNum, companyid, runNum, companyid, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_DEPTMGR_EXED_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	

	/**
	 * 
	 * 부서원역량진단 진단 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
	public String getDeptCmptEvlExec() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		int useridExed= Integer.parseInt(ParamUtils.getParameter(request, "USERID_EXED") + "");
		
		Object [] params = {
				companyid, runNum
		};
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		
		//역량정보 조회
		this.items = camService.queryForList("EVL.GET_CMPT_EVL_RUN_INFO", params, jdbcTypes);
		//피진단자정보 조회
		this.items1 = camService.queryForList("EVL.GET_USER_EXED_INFO", new Object[]{useridExed}, new int[]{Types.NUMERIC});
		this.items2 = camService.queryForList("EVL.GET_CMPT_EXAMPLE_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC}); //보기 목록
		request.setAttribute("RUN_NUM", ParamUtils.getParameter(request, "RUN_NUM"));
		request.setAttribute("TG_USERID", ParamUtils.getParameter(request, "USERID_EXED"));
		request.setAttribute("RUNDIRECTION_CD", ParamUtils.getParameter(request, "RUNDIRECTION_CD"));
		
		return success();
	}
	

	/**
	 * 
	 * 역량진단 자가진단 문항 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
	public String getCmptDeptEvlExecBhvList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		
		long companyid = getUser().getCompanyId();
		long execUserid = getUser().getUserId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		int tgUserid = Integer.parseInt(ParamUtils.getParameter(request, "TG_USERID", "0"));

		//진단문항 조회
		Object [] params1 = {
				companyid, companyid, tgUserid, companyid, tgUserid, 
				companyid, companyid, tgUserid, companyid, tgUserid, companyid, runNum, execUserid, tgUserid,
				companyid, runNum, execUserid, tgUserid, companyid, runNum, tgUserid
		};
		int[] jdbcTypes1 = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_DEPT_EVL_EXEC_BHV", params1, jdbcTypes1);
		this.totalItemCount = items.size();
		
		//진단 시작 시간 업데이트
		camService.update("EVL.START_EVL_TB_CAM_RUNDIRECTION_I", new Object[]{companyid, runNum, execUserid, tgUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		return success();
	}
	

	/**
	 * 
	 * 역량진단 역량별 분석 정보 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlCmptAnaly() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		int job = Integer.parseInt(ParamUtils.getParameter(request, "JOB", "0"));
		int leadership = Integer.parseInt(ParamUtils.getParameter(request, "LEADERSHIP", "0"));
		
		Object [] params = {
				companyid, runNum, tguserid,
				companyid, runNum, job,
				companyid, runNum, leadership
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_EVL_CMPT_ANALYSIS", params, jdbcTypes);
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 
	 * 역량진단분석 - 추천교육 목록 정보 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlRecommEduList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		Object [] params = {
				companyid, runNum, tguserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_EVL_RECOMM_EDU", params, jdbcTypes);
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 
	 * 역량진단분석 - 추천교육 목록 정보 조회(출력용 역량당 5개씩)<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlRecommEduPrintList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		Object [] params = {
				companyid, runNum, tguserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_EVL_RECOMM_EDU_PRINT", params, jdbcTypes);
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 
	 * 역량진단분석 - 추천교육 상세 정보 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlRecommEduDetail() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		String  subjectNum = ParamUtils.getParameter(request, "SUBJECT_NUM");

		this.items = camService.queryForList("EVL.GET_EDU_DETAIL_INFO", new Object[]{companyid, subjectNum}, new int[]{Types.NUMERIC, Types.VARCHAR});
		this.items1 = camService.queryForList("EVL.GET_EDU_CHASU_LIST", new Object[]{subjectNum}, new int[]{Types.VARCHAR});

		return success();
	}
	
	/**
	 * 
	 * 역량진단분석 - 추천교육 바로가기 URL 정보 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlRecommEduUrlInfo() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		String  subjectNum = ParamUtils.getParameter(request, "SUBJECT_NUM");
		
		Object [] params = {
				subjectNum
		}; 
		int[] jdbcTypes = {
				Types.VARCHAR
		};
		this.items = camService.queryForList("EVL.GET_EVL_RECOMM_EDU_URL_INFO", params, jdbcTypes);

		String tmpUrl = "";
		if(this.items!=null ){
			tmpUrl = ((Map)this.items.get(0)).get("SAMPLE_URL").toString();
		}
		this.statement = tmpUrl;
		return success();
	}
	
	/**
	 * 
	 * 역량진단분석 - 진단자 코멘트 정보 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlUserCmtAnaly() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		Object [] params = {
				companyid, runNum, tguserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_EVL_USER_CMT_ANALYSIS", params, jdbcTypes);
		this.totalItemCount = this.items.size();
		return success();
	}
	
	
	/**
	 * 
	 * 역량진단분석 - 역량성장도 진단 횟수 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlGrowListCnt() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		Object [] params = {
				companyid, tguserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_EVL_GROW_LIST_CNT", params, jdbcTypes);
		this.totalItemCount = Integer.parseInt(((Map)this.items.get(0)).get("CNT").toString());
		return success();
	}
	

	/**
	 * 
	 * 역량진단분석 - 역량성장도 역량 목록 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlGrowCmptList() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		Object [] params = {
				companyid, tguserid, companyid, tguserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_EVL_GROW_CMPT_LIST", params, jdbcTypes);
		
		return success();
	}
	
	/**
	 * 
	 * 역량진단분석 - 역량별 역량성장도 조회<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 20.
	 */
	public String getCmptEvlGrowInfo() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long tguserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		Object [] params = {
				companyid, tguserid, companyid, tguserid
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		List list = camService.queryForList("EVL.GET_EVL_GROW_CMPT_LIST", params, jdbcTypes);
		
		if(list!=null && list.size()>0){
			this.items = camService.getCmptEvlGrow(companyid, tguserid, list);
		}
		return success();
	}
	

	/**
	 * 
	 * 역량진단결과 출력<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCmptRunPrint() throws CAMException{
		Object [] params = {
				getUser().getCompanyId(), getUser().getUserId(),
				getUser().getCompanyId(), getUser().getUserId(),
				getUser().getCompanyId(), getUser().getUserId(),
				getUser().getCompanyId(), getUser().getUserId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_EVL_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 다면역량진단 ( 일반사용자) 진단 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCmptEvlMsdRunList() throws CAMException{
		Object [] params = {
				getUser().getCompanyId(), getUser().getUserId(),
				getUser().getCompanyId(), getUser().getUserId(),
				getUser().getCompanyId(), getUser().getUserId(),
				getUser().getCompanyId(), getUser().getUserId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_EVL_MSD_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 *  다면역량진단 진단별 피진단자 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 17.
	 */
	public String getCmptEvlMsdExedPg() throws CAMException{
		log.debug(CommonUtils.printParameter(request));
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM").toString());

		Object [] params = {
				getUser().getCompanyId(), getUser().getUserId(), getUser().getCompanyId(), runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = camService.queryForList("EVL.GET_CMPT_MSD_RUN_INFO", params, jdbcTypes);
		List list = camService.queryForList("EVL.GET_COMPANY_OPERATOR_USER_INFO", new Object[]{getUser().getCompanyId(),}, new int[]{Types.NUMERIC});
		
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			String decPhone = "";
			try {
				if(map.get("PHONE")!=null){
					decPhone = CommonUtils.ASEDecoding(map.get("PHONE").toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			map.put("DEC_PHONE", decPhone);
			this.items1 = new ArrayList();
			this.items1.add(map);
		}
		return success();
	}
	
	
	/**
	 * 
	 * 다면역량진단 자가진단 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 15.
	 */
	public String getCmptEvlMsdSelfExec() throws CAMException{
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		
		//역량정보 조회
		Object [] params = {
				companyid, runNum
		};
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		
		this.items = camService.queryForList("EVL.GET_CMPT_EVL_RUN_INFO", params, jdbcTypes);
		this.items1 = camService.queryForList("EVL.GET_CMPT_EXAMPLE_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC}); //보기 목록
		
		request.setAttribute("RUN_NUM", ParamUtils.getParameter(request, "RUN_NUM"));
		request.setAttribute("TG_USERID", ParamUtils.getParameter(request, "TG_USERID"));
		
		return success();
	}
	
	/**
	 * 
	 * 세션유지용 메소드<br/>
	 *
	 * @return
	 * @since 2015. 3. 24.
	 */
	public String getCmptContinue(){
		this.statement = "Y";
		return success();
	}
	
}