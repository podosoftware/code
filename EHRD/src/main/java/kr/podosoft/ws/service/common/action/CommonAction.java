package kr.podosoft.ws.service.common.action;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.sql.Blob;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.CommonService;
import kr.podosoft.ws.service.common.MailSenderService;
import kr.podosoft.ws.service.common.MainService;
import kr.podosoft.ws.service.utils.CommonUtils;
import net.coobird.thumbnailator.Thumbnails;

import org.apache.struts2.dispatcher.multipart.MultiPartRequestWrapper;

import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.UploadAttachmentAction;
import architecture.ee.web.util.ParamUtils;

public class CommonAction extends UploadAttachmentAction{

	private static final long serialVersionUID = 3495458863220566069L;
	

	//private String ssoStuPersnlNbr;
	
	//private static final String API_KEY = "368B184727E89AB69FAF";
	
	
	private String targetAttachmentContentType = "";
	private int targetAttachmentContentLength = 0;
	private InputStream targetAttachmentInputStream = null;
	private String targetAttachmentFileName = "";
	
	private CommonService commonSrv;
	
	private MainService mainSrv;
	
	private MailSenderService mailSenderSrv;
	
	private List items;
	
	private List items1;
	
	private long filesize = 0;
	
	 private int totalItemCount = 0;	
	
	
	private String statement;
	private String approval;
	private String board;
	private String edu;
	
	
	public String getApproval() {
		return approval;
	}

	public void setApproval(String approval) {
		this.approval = approval;
	}

	public String getBoard() {
		return board;
	}

	public void setBoard(String board) {
		this.board = board;
	}

	public String getEdu() {
		return edu;
	}

	public void setEdu(String edu) {
		this.edu = edu;
	}

	public MailSenderService getMailSenderSrv() {
		return mailSenderSrv;
	}

	public void setMailSenderSrv(MailSenderService mailSenderSrv) {
		this.mailSenderSrv = mailSenderSrv;
	}
	public int getTotalItemCount() {
		return totalItemCount;
	}

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	public String getStatement() {
		return statement;
	}
	

	public void setStatement(String statement) {
		this.statement = statement;
	}

	public long getFilesize() {
		return filesize;
	}

	public void setFilesize(long filesize) {
		this.filesize = filesize;
	}

	public MainService getMainSrv() {
		return mainSrv;
	}

	public void setMainSrv(MainService mainSrv) {
		this.mainSrv = mainSrv;
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
	
	public CommonService getCommonSrv() {
		return commonSrv;
	}
	public void setCommonSrv(CommonService commonSrv) {
		this.commonSrv = commonSrv;
	}
	
	public String getTargetAttachmentContentType() {
		return targetAttachmentContentType;
	}

	public void setTargetAttachmentContentType(String targetAttachmentContentType) {
		this.targetAttachmentContentType = targetAttachmentContentType;
	}

	public int getTargetAttachmentContentLength() {
		return targetAttachmentContentLength;
	}

	public void setTargetAttachmentContentLength(int targetAttachmentContentLength) {
		this.targetAttachmentContentLength = targetAttachmentContentLength;
	}

	public InputStream getTargetAttachmentInputStream() {
		return targetAttachmentInputStream;
	}

	public void setTargetAttachmentInputStream(
			InputStream targetAttachmentInputStream) {
		this.targetAttachmentInputStream = targetAttachmentInputStream;
	}

	public String getTargetAttachmentFileName() {
		try{
			targetAttachmentFileName = URLEncoder.encode(targetAttachmentFileName, "UTF-8");
		}catch(Exception e){
			
		}
		return targetAttachmentFileName;
	}

	public void setTargetAttachmentFileName(String targetAttachmentFileName) {
		this.targetAttachmentFileName = targetAttachmentFileName;
	}
	
	private int defaultNumber(Object obj) {
		try {
			if(obj!=null && !obj.equals("")) {
				return Integer.parseInt(obj.toString());
			} else {
				return 0;
			}
		} catch(Throwable e) {
			return 0;
		}
	} 
	
	/**
	 * 이미지 썸네일 추출
	 * @return
	 * @throws Exception
	 */
	public String getImgThumbnail() throws Exception {
		
		log.info("## getImgThumbnail");
		
		String fileNum = ParamUtils.getStringParameter(request, "filenum");
		String fileSeq = ParamUtils.getStringParameter(request, "fileseq");
		int width = ParamUtils.getIntParameter(request, "width",100);;
		int height = ParamUtils.getIntParameter(request, "height",100);;
		
		log.info("## getImgThumbnail parameter fileNum [" + fileNum + "]");
		log.info("## getImgThumbnail parameter fileSeq [" + fileSeq + "]");
		log.info("## getImgThumbnail parameter width [" + width + "]");
		log.info("## getImgThumbnail parameter height [" + height + "]");
		
		File originalFile = null; // original image file
		File file = null; // thumbnail image file
		
		try {
			Map<String,Object> imgData = commonSrv.getImgFileInfo(fileNum, fileSeq);
			// FILE_NAME, ORIGINAL_FILE_NAME, FILE_SIZE, CONTENT_TYPE
			
			File dir = ApplicationHelper.getRepository().getFile("tumbnail");
			log.info("PATH :: " + dir.getPath());
			if(!dir.exists())
				dir.mkdir();
			
			String savePath = dir.getPath();
			
			if(imgData!=null) {
				
				String orgFileName = imgData.get("ORIGINAL_FILE_NAME").toString();
				String url1 = savePath+"/"+fileNum+"_"+fileSeq+"."+(orgFileName.substring(orgFileName.lastIndexOf(".")+1));
				String url2 = savePath+"/"+fileNum+"_"+fileSeq+"_thumbnail.png";
				log.debug("orig :: " + url1);
				log.debug("thum :: " + url2);
				
				file = new File(url1);
				log.info("file chk :: " + file.isFile());
				
				if(!file.isFile()) {
					log.debug(" is file false");
						
					Blob blob = commonSrv.getImgFileData(fileNum, fileSeq);
					InputStream istream = blob.getBinaryStream(); 
					log.debug("---------------------------------------- 1");
					
					FileOutputStream foStream = new FileOutputStream(url1);
					byte abyte[] = new byte[4096];
					int i;
					while((i = istream.read(abyte)) != -1) {
						foStream.write(abyte, 0, i);
					}
					istream.close();
					foStream.close();
					
					log.debug("---------------------------------------- 2");
					
					File file1 = new File(url1);

					BufferedImage originalImage = ImageIO.read(file1);
					log.debug("Origin width :" + originalImage.getWidth() + ", height : "+originalImage.getHeight());
					log.debug("---------------------------------------- 3");
					String fileType = imgData.get("CONTENT_TYPE").toString();
					log.debug("Origin fileType :" + fileType);
					log.debug("---------------------------------------- 4");
					BufferedImage thumbnail = Thumbnails.of(originalImage).size(width, height).asBufferedImage();
					log.debug("thumbnail width :" + thumbnail.getWidth() + ", height : "+thumbnail.getHeight());
					log.debug("---------------------------------------- 5");
					
					file = new File(url2);
					ImageIO.write(thumbnail, "png", file);
					log.debug("Origin file :" + file.length());
					log.debug("---------------------------------------- 6");
				} else {
					log.debug(" is file true");
					if(file.length() != defaultNumber(imgData.get("FILE_SIZE"))) {
						// local file is defferent db fileData
						
						log.debug(" original file delete");
						file.delete();
						log.debug(" thumbnail file delete");
						file = null;
						file = new File(url2);
						if(file.isFile()) {
							file.delete();
						}
						file = null;
						
						Blob blob = commonSrv.getImgFileData(fileNum, fileSeq);
						InputStream istream = blob.getBinaryStream(); 
						log.debug("---------------------------------------- 1");
						
						FileOutputStream foStream = new FileOutputStream(url1);
						byte abyte[] = new byte[4096];
						int i;
						while((i = istream.read(abyte)) != -1) {
							foStream.write(abyte, 0, i);
						}
						istream.close();
						foStream.close();
						
						log.debug("---------------------------------------- 2");
						
						File file1 = new File(url1);

						BufferedImage originalImage = ImageIO.read(file1);
						log.debug("Origin width :" + originalImage.getWidth() + ", height : "+originalImage.getHeight());
						log.debug("---------------------------------------- 3");
						String fileType = imgData.get("CONTENT_TYPE").toString();
						log.debug("Origin fileType :" + fileType);
						log.debug("---------------------------------------- 4");
						BufferedImage thumbnail = Thumbnails.of(originalImage).size(width, height).asBufferedImage();
						log.debug("thumbnail width :" + thumbnail.getWidth() + ", height : "+thumbnail.getHeight());
						log.debug("---------------------------------------- 5");
						
						file = new File(url2);
						ImageIO.write(thumbnail, "png", file);
						log.debug("Origin file :" + file.length());
						log.debug("---------------------------------------- 6");
						
					} else {
						// local file of the same db fileData
						file = new File(url2);
					}
				}
			}

			this.targetAttachmentContentType = imgData.get("CONTENT_TYPE").toString();
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);
			this.targetAttachmentFileName = imgData.get("FILE_NAME").toString();
			
			log.debug("targetAttachmentContentType :: " + targetAttachmentContentType);
			log.debug("targetAttachmentContentLength :: " + targetAttachmentContentLength);
			log.debug("targetAttachmentFileName :: " + targetAttachmentFileName);
			
		} catch(Exception e) {
			log.error(e);
		}
		
		return success();
	}
	
	
	/**
	 * 공통 - 도메인 정보
	 * 상단정보
	 * @return
	 * @throws Exception
	 */
	public String getDomainChk() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
	
		String subDomain = ParamUtils.getParameter(request, "SUB_DOMAIN");

		List list = mainSrv.queryForList("COMMON.GET_DOMAIN_CHECK", new Object[]{subDomain}, new int[]{Types.VARCHAR});
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			String phone  = "";
			if(map.get("PHONE")!=null){
				try{
					phone = CommonUtils.ASEDecoding(map.get("PHONE").toString());
				}catch(Exception e){}
				
				if(phone!=null && phone.length()>=9){
					String tmp = phone;
					
					if(tmp.indexOf("02")>-1){
						phone = tmp.substring(0, 2)+")"+tmp.substring(2, tmp.length()-4)+"."+tmp.substring( tmp.length()-4);
					}else{
						phone = tmp.substring(0, 3)+")"+tmp.substring(3, tmp.length()-4)+"."+tmp.substring( tmp.length()-4);
					}
				}
			}
			map.put("INC_PHONE", phone);
			String email= "";
			if(map.get("EMAIL")!=null){
				try{
					email = CommonUtils.ASEDecoding(map.get("EMAIL").toString());
				}catch(Exception e){}
			}
			map.put("INC_EMAIL", email);
			
			this.items = new ArrayList();
			this.items.add(map);
		}
		return success();
	}

	public String imageFileView() throws CommonException{
		
		String tmpCid  = ParamUtils.getParameter(request, "companyId", "");
		if(tmpCid!=null && !tmpCid.equals("")){
			int cid = Integer.parseInt(tmpCid);
			
			List list = mainSrv.queryForList("COMMON.SELECT_FILE_INFO", new Object[]{"3", cid}, new int[]{ Types.VARCHAR, Types.NUMERIC } );
			if(list!=null && list.size()>0){
				Map map = (Map)list.get(0);
				
				this.targetAttachmentContentType = (String)map.get("CONTENT_TYPE");
				this.targetAttachmentContentLength = Integer.parseInt(map.get("FILE_SIZE").toString());
				this.targetAttachmentInputStream = (InputStream)mainSrv.queryForInputStream("COMMON.SELECT_FILE_DATA", new Object[]{"3", cid}, new int[]{ Types.VARCHAR, Types.NUMERIC });
				this.targetAttachmentFileName = (String)map.get("FILE_NAME");
			}
			if( log.isDebugEnabled() ) {
				log.debug("targetAttachmentContentType : " + this.targetAttachmentContentType);
				log.debug("targetAttachmentContentLength : " + this.targetAttachmentContentLength);
				log.debug("targetAttachmentInputStream : " + this.targetAttachmentInputStream);
				log.debug("targetAttachmentFileName : " + this.targetAttachmentFileName);
			}
		}
		
		return success();
	}
	

	/**
	 * 
	 * 첨부파일 파일사이즈 조회..<br/>
	 *
	 * @return
	 * @since 2014. 5. 23.
	 */
	public String getFileSize() {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		try
	     {

			MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
			File file= multiWrapper.getFiles("files")[0];
          
			// 파일 크기
			this.filesize = file.length(); 
			
		} catch (Exception e) {
			e.printStackTrace();
			this.filesize = -1;
		}
		
		return success();
		
	}

	/**
	 * 
	 * 비밀번호 찾기<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 5. 29.
	 */
	public String getPwdSearch() throws Exception {
		if(log.isDebugEnabled()) CommonUtils.printParameter(request);
		
			String empno = ParamUtils.getParameter(request, "empno"); 
			String name = ParamUtils.getParameter(request, "name");
			String email = ParamUtils.getParameter(request, "email");
			String companyid = ParamUtils.getParameter(request, "companyid");
			
			String output = ParamUtils.getParameter(request, "output");
			
			this.items = new ArrayList();
			Map dmap = new HashMap();
			
			if(empno!=null && name!=null && email!=null) {
				// 요청된 데이터에 따른 사용자 정보가 존재하는지 검색
				String encEmail = CommonUtils.ASEEncoding(email);
				List userList= mainSrv.queryForList("BA.GET_PW_SEARCH_INFO", new Object[] {empno, name, encEmail, companyid}, new int[] {Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC});
				log.debug("userList :"+userList.size() );
				if(userList!=null && userList.size()>0){
					
					Map map  = (Map)userList.get(0);
					String userid = map.get("USERID")+"";
					log.debug("userid :"+userid );
					//입력한 정보에 따른 사용자가 존재하므로 임시비밀번호 생성 후 요청 이메일로 전송..
					
					// 임시 비밀번호를 생성한다.(8자리)
					String newPwd = CommonUtils.randomStr(8);
					String encNewPwd = CommonUtils.passwdEncoding(newPwd);
					
					//비밀번호 변경 처리.
					mainSrv.update("BA.UPDATE_PWD", new Object[]{encNewPwd, userid	}, new int[]{Types.VARCHAR, Types.NUMERIC});
					
					//이메일 전송..
					List<Map<String,Object>> mailInfoList = mainSrv.queryForList("BA.GET_OPERATOR_EMAIL", new Object[]{companyid}, new int[]{Types.NUMERIC});
					// 발송자 정보추출(성명,이메일) --> 고객사 운영자 정보 조회..
					
					String subjectName = "";
					String fromUser = "";
					String toUser = "";
					StringBuffer sb = new StringBuffer(); // 본문내용
					
					String fromName = "";
					String incFromMail = "";
					String decFromMail = "";
					if(mailInfoList!=null && mailInfoList.size()>0) {
						Map<String,Object> row = mailInfoList.get(0);
						
						if(row.get("FROM_NAME")!=null){
							fromName = row.get("FROM_NAME").toString();
						}
						if(row.get("FROM_EMAIL")!=null){
							incFromMail = row.get("FROM_EMAIL").toString();
							decFromMail = CommonUtils.ASEDecoding(incFromMail);
						}
					}else{
						//고객사운영자의 메일정보가 없다면, MPVA총괄담당자 메일정보를 조회
						List<Map<String,Object>> mpvamailList = mainSrv.queryForList("BA.GET_OPERATOR_EMAIL", new Object[]{ 1 }, new int[]{Types.NUMERIC});
						if(mpvamailList!=null && mpvamailList.size()>0) {
							Map<String,Object> row = mpvamailList.get(0);
							
							if(row.get("FROM_NAME")!=null){
								fromName = row.get("FROM_NAME").toString();
							}
							if(row.get("FROM_EMAIL")!=null){
								incFromMail = row.get("FROM_EMAIL").toString();
								decFromMail = CommonUtils.ASEDecoding(incFromMail);
							}
						}
					}
					
					//발신 이메일 정보가 온전한 경우에만 메일 발송.
					if(decFromMail!=null && !decFromMail.equals("") ){
						fromUser = decFromMail;
						toUser = email;
						
						//제목 mpva 제공..
						subjectName = "[MPVA 시스템] 임시 비밀번호를 발송했습니다.";
						
						sb.append(subjectName);
						sb.append("<br><br>"+name+"님의 임시 비밀번호는 " + newPwd  + " 입니다");
						sb.append("<br><br><br>로그인 후 비밀번호를 변경하여 사용하시길 바랍니다.<br><br><br>");
						sb.append("<br><br><br>감사합니다.<br><br><br>");
						
						Map<String,String> contents = new HashMap<String, String>();
						contents.put("CONTENTS", sb.toString());
						
						log.debug("send mail.........");
						
						log.debug("####### fromUser : " + fromUser + ", toUser : " + toUser);
						
						mailSenderSrv.mailSender(subjectName, contents, fromUser, toUser, null, false);
						this.statement = "SUCCESS";
					}else{
						this.statement = "NoFromMail";
					}
				}else{
					this.statement = "NoUserData";
				}
			} else {
				this.statement = "NoData";
			}
			
			log.debug("@@@@@ this.statement:"+this.statement);
			
			return success();
		
	}
	
	/**
	 * 
	 * 포털연동용 메소드 - 결재요청건수, 교육안내 게시물 건수, 모집중인과정 건수 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2015. 4. 10.
	 */
	public String getPortalReqData() throws Exception{
		//ssotoken의 유효성을 통해 로그인 체크..
		/*String ssoToken = null;
		int ssoResult = 0;
		int ssoLastErr = 0;		
		String ssoLastErrMsg = null;
		SSO context = new SSO(API_KEY);
		
		ssoToken = CommonUtils.getCookieValue(request, "ssotoken");
		
		this.approval = "0";
		this.board = "0";
		this.edu = "0";
		
		if ( ssoToken == null || ssoToken.length() < 1 ) {
			//쿠키값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
			//System.out.println("SSO Cookie not exist");

	        log.debug("### getPortalReqData SSO Cookie not exist ");
	        
		} else {
			ssoResult = context.verifyToken(ssoToken, request.getRemoteAddr());
		    if ( ssoResult < 0 ) {
		    	//결과값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
		    	
		        ssoLastErr = context.getLastError();
		        ssoLastErrMsg = context.getLastErrorMsg();
		        
		        log.debug("############# getPortalReqData sso error..... "+ssoLastErr + " : " + ssoLastErrMsg);
		    } else {
		    	ssoStuPersnlNbr = context.getValue("USER_HRSSID"); //교직원번호 empno로 사용됨..
				
				List<Map<String,Object>> list = mainSrv.queryForList("COMMON.SELECT_PORTAL_REQ_CNT", 
						new Object[] {ssoStuPersnlNbr, ssoStuPersnlNbr, ssoStuPersnlNbr, ssoStuPersnlNbr, ssoStuPersnlNbr}, 
						new int[] {Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR});
				
				if(list!=null && list.size()>0) {
					
					Map<String,Object> item = list.get(0);
					
					this.approval = item.get("APPROVAL_CNT").toString();
					this.board = item.get("BOARD_CNT").toString();
					this.edu = item.get("EDU_CNT").toString();
				}
		    }
		}
		*/
		
		this.approval = "0";
		this.board = "0";
		this.edu = "0";
		
    	String ssoStuPersnlNbr = ParamUtils.getParameter(request, "user_hrssid"); //교직원번호 empno로 사용됨..
		
		List<Map<String,Object>> list = mainSrv.queryForList("COMMON.SELECT_PORTAL_REQ_CNT", 
				new Object[] {ssoStuPersnlNbr, ssoStuPersnlNbr, ssoStuPersnlNbr, ssoStuPersnlNbr, ssoStuPersnlNbr}, 
				new int[] {Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR});
		
		if(list!=null && list.size()>0) {
			
			Map<String,Object> item = list.get(0);
			
			this.approval = item.get("APPROVAL_CNT").toString();
			this.board = item.get("BOARD_CNT").toString();
			this.edu = item.get("EDU_CNT").toString();
		}
		
		return success();
	}
	
}
