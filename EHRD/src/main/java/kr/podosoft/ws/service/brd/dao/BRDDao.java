package kr.podosoft.ws.service.brd.dao;

import java.io.InputStream;
import java.util.List;

import kr.podosoft.ws.service.brd.BRDException;

import architecture.common.user.User;

public interface BRDDao {
	
	public int deleteCommunityFileDao(String boardCode, String boardNum) throws BRDException; 
	
	public String getFileContentType(int fileNum, int seqNum);
	 
	public String getFileContentLength(int fileNum, int seqNum);

	public InputStream getInputStream(int fileNum, int seqNum);
	
	public String getFileName(int fileNum, int seqNum);

	public List getOneContentList(String subjectNum, int year, int chasu,
			String content, User user);
	
	public long getMaxFileNum();
	
	public int maxBoardNum(String boardCode, long companyId);
	
	public int insertFile(long companyId, long fileNum, String fileName, long fileSize, InputStream file , String contentType, long userId);
	
	public void fileNumUpdate(long companyId, String boardCode,  int boardNum, long fileNum); 
	
	public int fileDelete(int fileNum, int seqNum);
	
	public int getBoardFileNum(long companyId, String boardCode, String boardNum);
 
	public List getBoardListDao(String boardCode, long userId);

	public List getBoardDetailDao(String boardCode, String boardNum, long userId);

	public List competencyListDao(long companyId);

	public List getBoardDetailFileListDao(String boardCode, String boardNum);

	public List getBoardDetailCmpListDao(long companyId, String boardCode, String boardNum);

	public void updateViewCnt(String boardCode, String boardNum);

	public int saveBoard(String boardCode, int boardNum, String boardTittle,
			String boardContent, String actSdate, String actEdate, String noticeFlag, 
			long userId, String upBoardNum);

	public int updateBoard(String boardTittle, String boardContent,
			String actSdate, String actEdate, String noticeFlag, long userId, String boardCode,
			String boardNum);

	public int boardDeleteDao(String boardCode, String boardNum);
	
	public int boardReplyDeleteDao(String boardCode, String boardNum);

	public void insertBrdCmptMap(String boardCode, int boardNum,
			long companyId, String cmpNumber);

	public void deleteBrdCmptMap(String boardCode, int boardNum, long companyId);
	
	
		
}
