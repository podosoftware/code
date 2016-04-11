package kr.podosoft.ws.service.brd.impl;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.*;

import kr.podosoft.ws.service.brd.BRDException;
import kr.podosoft.ws.service.brd.BRDService;
import kr.podosoft.ws.service.brd.dao.BRDDao;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.common.user.User;
import architecture.ee.web.attachment.FileInfo;

public class BRDServiceImpl implements BRDService {
	
	private Log log = LogFactory.getLog(getClass());
	
	private BRDDao brdDao;

	public BRDDao getBrdDao() {
		return brdDao;
	}

	public void setBrdDao(BRDDao brdDao) {
		this.brdDao = brdDao;
	}
	
	 
	/**
	 * 게시판리스트 
	 */
	public List getBoardList(String boardCode, long userId) {

		return brdDao.getBoardListDao(boardCode, userId);
	}

	 public List competencyList(User user) {

		return brdDao.competencyListDao(user.getCompanyId());
	}

	public List getBoardDetail(String boardCode, String boardNum,  long userId) {
		
		brdDao.updateViewCnt(boardCode, boardNum);
		
		 return brdDao.getBoardDetailDao(boardCode, boardNum, userId);
	}

	public List getBoardDetailFileList(String boardCode, String boardNum) {

		return brdDao.getBoardDetailFileListDao(boardCode, boardNum);
	}

	public List getBoardDetailCmpList(long companyId, String boardCode, String boardNum) {

		return brdDao.getBoardDetailCmpListDao(companyId, boardCode, boardNum);
	}
	 
	 @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BRDException.class )
	 public int saveBoard(String boardCode, String boardTittle,
			String boardContent, String actSdate, String actEdate, String noticeFlag, 
			List<FileInfo> fileList, User user, List<Map<String, Object>> cmpList) { 
		 	int saveResult = 0;
			long fileNum = 0;
			
			int boardNum = brdDao.maxBoardNum(boardCode, user.getCompanyId());
			
			log.debug("fileList 사이즈 : " + fileList.size());
			
			try{
				
				saveResult = brdDao.saveBoard(boardCode, boardNum, boardTittle, boardContent, actSdate, actEdate, noticeFlag, user.getUserId(), "0" );
				
				//대내외활동정보경우에만 역량맵핑을한다.
				if(boardCode.equals("7") || boardCode.equals("8")){
					for(Map map : cmpList){
						String cmpNumber = map.get("CMPNUMBER").toString();
						
						brdDao.insertBrdCmptMap(boardCode, boardNum, user.getCompanyId(), cmpNumber);
					}
				}
				
				if(fileList.size() > 0){
					log.debug("fileSize : " + fileList.size()) ;
					
					fileNum = brdDao.getMaxFileNum();
					
					log.debug("fileNum : " +  fileNum);
					for( FileInfo f : fileList){
						InputStream in = new FileInputStream(f.getFile());
						brdDao.insertFile(user.getCompanyId(), fileNum, f.getName(),  f.getFile().length(), in, f.getContentType(), user.getUserId());
					}
				}
			
				if(fileList.size() != 0){
					brdDao.fileNumUpdate(user.getCompanyId(), boardCode, boardNum, fileNum);
				}
				
			}catch(Exception e){
				
			}
			
			return saveResult;
	}
	 
	 
	
	public int boardReplyCreate(String boardCode, String upBoardNum, String boardTittle,
			String boardContent, List<FileInfo> fileList, User user) {

	 	int saveResult = 0;
		long fileNum = 0;
		
		int boardNum = brdDao.maxBoardNum(boardCode, user.getCompanyId());
		
		log.debug("fileList 사이즈 : " + fileList.size());
		
		try{
			 
			brdDao.saveBoard(boardCode, boardNum, boardTittle, boardContent, "", "",  "N", user.getUserId(),  upBoardNum);
			
			if(fileList.size() > 0){
				log.debug("fileSize : " + fileList.size()) ;
				
				fileNum = brdDao.getMaxFileNum();
				
				log.debug("fileNum : " +  fileNum);
				for( FileInfo f : fileList){
					InputStream in = new FileInputStream(f.getFile());
					saveResult = brdDao.insertFile(user.getCompanyId(), fileNum, f.getName(),  f.getFile().length(), in, f.getContentType(), user.getUserId());
				}
			}
		
			if(fileList.size() != 0){
				brdDao.fileNumUpdate(user.getCompanyId(), boardCode, boardNum, fileNum);
			}
			
		}catch(Exception e){
			
		}
		
		return saveResult;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BRDException.class )
	public int updateBoard(String boardCode, String boardNum,
			String boardTittle, String boardContent, String actSdate,
			String actEdate, List<FileInfo> fileList, User user, String noticeFlag, List<Map<String, Object>> cmpList) {
		 
		long fileNum = brdDao.getBoardFileNum(user.getCompanyId(), boardCode, boardNum);
		
		int cnt = 0;
		
		try{
			cnt = brdDao.updateBoard(boardTittle, boardContent, actSdate, actEdate, noticeFlag, user.getUserId(),  boardCode, boardNum);
			
			
			//대내외활동정보경우에만 역량맵핑을한다.
			if(boardCode.equals("7") || boardCode.equals("8")){
				brdDao.deleteBrdCmptMap(boardCode, Integer.parseInt(boardNum), user.getCompanyId());
				
				for(Map map : cmpList){
					String cmpNumber = map.get("CMPNUMBER").toString();
					
					brdDao.insertBrdCmptMap(boardCode, Integer.parseInt(boardNum), user.getCompanyId(), cmpNumber);
				}
			}
			
			
			if(fileNum == 0){
				log.debug("fileSize : " + fileList.size()) ;
				if(fileList.size() >= 1){
					fileNum = brdDao.getMaxFileNum();
				}
			}
			
			for( FileInfo f : fileList){
				
				log.debug("fileCurrnet");
				InputStream in = new FileInputStream(f.getFile());
				brdDao.insertFile(user.getCompanyId(), fileNum, f.getName(),  f.getFile().length(), in, f.getContentType(), user.getUserId());
				
			}
			
		
			if(fileList.size() != 0){
				brdDao.fileNumUpdate(user.getCompanyId(), boardCode, Integer.parseInt(boardNum), fileNum);
			}
			
		}catch(Exception e){
			log.error(e);
		}
		
		return cnt;
	}

	public Map fileDownloadInfo(int fileNum, int seqNum) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String contentType    = brdDao.getFileContentType(fileNum, seqNum);
		String contentLength = brdDao.getFileContentLength(fileNum, seqNum);
		InputStream is           = brdDao.getInputStream(fileNum, seqNum);
		String fileName          = brdDao.getFileName(fileNum, seqNum);
		
		map.put("contentType", contentType);
		map.put("contentLength", contentLength);
		map.put("is", is);
		map.put("fileName", fileName);
		
		return map;
	}
	
	
	/**
	 * 게시글삭제
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BRDException.class )
	public int boardDelete(String boardCode, String boardNum, long companyId) {
		int result = 0;
		try{
			//대내외활동정보 게시판인경우 역량 리스트를 우선 삭제시킨다.
			if(boardCode.equals("7") || boardCode.equals("8")){
				brdDao.deleteBrdCmptMap(boardCode, Integer.parseInt(boardNum), companyId);
			}
			
			// 첨부파일 삭제
			brdDao.deleteCommunityFileDao(boardCode, boardNum);
			
			// 리플 삭제
			brdDao.boardReplyDeleteDao(boardCode, boardNum);
			
			// 게시글 삭제
			result = brdDao.boardDeleteDao(boardCode, boardNum);
			
		}catch(BRDException e){
			log.debug(e.toString());
			return 0;
		}
		return result;
	}

	public int fileDelete(int fileNum, int seqNum) {

		return brdDao.fileDelete(fileNum, seqNum);
	}
	
	/**
	 * 
	 * 파일 업로드 - 파일리스트를 DB에 저장 후 filenum을 리턴.<br/>
	 * 
	 * @param user
	 * @param fileList
	 * @return
	 * @since 2014. 4. 4.
	 */
	public long fileUpload(User user, List<FileInfo> fileList){
		long fileNum = 0;
		try{
			if(fileList.size() > 0){
				log.debug("fileListSize : " + fileList.size()) ;
				
				fileNum = brdDao.getMaxFileNum();
				
				log.debug("fileNum : " +  fileNum);
				for( FileInfo f : fileList){
					InputStream in = new FileInputStream(f.getFile());
					brdDao.insertFile(user.getCompanyId(), fileNum, f.getName(),  f.getFile().length(), in, f.getContentType(), user.getUserId());
				}
			}
		}catch(Exception e){
			log.error(e);
		}
		return fileNum;
	}

}
