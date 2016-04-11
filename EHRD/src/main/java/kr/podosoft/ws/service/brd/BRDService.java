package kr.podosoft.ws.service.brd;

import java.util.List;
import java.util.Map;

import architecture.common.user.User;
import architecture.ee.web.attachment.FileInfo;

public interface BRDService {

    public Map fileDownloadInfo(int fileNum, int seqNum) ;
    
    public int fileDelete(int fileNum, int seqNum) ;

	public List getBoardList(String boardCode, long userId);

	public List getBoardDetail(String boardCode, String boardNum, long userId);

	public List competencyList(User user); 

	public List getBoardDetailFileList(String boardCode, String boardNum);

	public List getBoardDetailCmpList(long companyId, String boardCode, String boardNum);

	public int saveBoard(String boardCode, String boardTittle,
			String boardContent, String actSdate, String actEdate,
			String noticeFlag, List<FileInfo> list, User user, List<Map<String, Object>> cmpList);

	public int updateBoard(String boardCode, String boardNum,
			String boardTittle, String boardContent, String actSdate,
			String actEdate, List<FileInfo> list, User user, String noticeFlag, List<Map<String, Object>> cmpList);
 
	public int boardDelete(String boardCode, String boardNum, long l);

	public int boardReplyCreate(String boardCode, String upBoardNum, String boardTittle,
			String boardContent, List<FileInfo> list, User user);  
    
	public long fileUpload(User user, List<FileInfo> fileList);
	
}
