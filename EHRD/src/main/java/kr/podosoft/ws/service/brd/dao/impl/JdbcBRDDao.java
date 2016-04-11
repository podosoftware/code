package kr.podosoft.ws.service.brd.dao.impl;

import java.io.InputStream;
import java.sql.Types;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.brd.BRDException;
import kr.podosoft.ws.service.brd.dao.BRDDao;

import architecture.common.user.User;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcBRDDao  extends SqlQueryDaoSupport implements BRDDao  {
	
	

	public void deleteBrdCmptMap(String boardCode, int boardNum, long companyId) {

		getSqlQuery().update("BRD.DELETE_BRD_CMPT_MAP", boardCode, boardNum, companyId);
		
	}

	public void insertBrdCmptMap(String boardCode, int boardNum,
			long companyId, String cmpNumber) {

		getSqlQuery().update("BRD.INSERT_BRD_CMPT_MAP", boardCode, boardNum, companyId, cmpNumber);
		
	}

	public int boardDeleteDao(String boardCode, String boardNum) {

		return getSqlQuery().update("BRD.DELETE_BOARD", boardCode, boardNum);
	}
	
	public int boardReplyDeleteDao(String boardCode, String boardNum) {
		
		return getSqlQuery().update("BRD.DELETE_BOARD_REPLY", boardCode, boardNum);
	}

	public void updateViewCnt(String boardCode, String boardNum) { 

		getSqlQuery().update("BRD.UPDATE_BOARD_VIEW_COUNT", boardCode, boardNum);;
	}

	public List getBoardDetailFileListDao(String boardCode, String boardNum) {
		// TODO Auto-generated method stub
		return getSqlQuery().list("BRD.GET_BOARD_FILE_LIST", boardCode, boardNum);
	}

	public List getBoardDetailCmpListDao(long companyId, String boardCode, String boardNum) {
		// TODO Auto-generated method stub
		return getSqlQuery().list("BRD.GET_BOARD_CMP_LIST", boardCode, boardNum, companyId);
	}

	public List<Map<String, Object>> getBoardListDao(String boardCode, long userId) {
		// TODO Auto-generated method stub
		return getSqlQuery().list("BRD.GET_BOARD_LIST", userId, boardCode, userId, boardCode);
	}
	
	public List getBoardDetailDao(String boardCode, String boardNum, long userId) {
		// TODO Auto-generated method stub
		return getSqlQuery().list("BRD.GET_BOARD_DETAIL", userId, boardCode, boardNum);
	}

	public List competencyListDao(long companyId) {
		// TODO Auto-generated method stub
		return getSqlQuery().list("BRD.GET_COMPETENCY_LIST", companyId);
	}
	
	public int deleteCommunityFileDao( String boardCode, String boardNum) throws BRDException{
		
		int result = 0;
		
		try{
			result = getSqlQuery().update("BRD.DELETE_COMMUNITY_FILE", boardCode, boardNum);
		}catch(Exception e){
			log.error(e); 
			throw new BRDException( e );
		}
		return result;
	}
	
	public int saveBoard(String boardCode, int boardNum, String boardTittle,
			String boardContent, String actSdate, String actEdate, String noticeFlag,
			long userId, String upBoardNum) {
		
		SqlQueryHelper helper = new SqlQueryHelper(getLobHandler());
		helper.lob(boardContent);

		return getSqlQuery().update("BRD.INSERT_TB_BRD_BOARD", new Object[]{boardCode, boardNum, boardTittle, helper.values()[0], actSdate, actEdate, userId, upBoardNum, noticeFlag}, 
																								 new int[]{Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, Types.CLOB, Types.VARCHAR, Types.VARCHAR, 
																								Types.NUMERIC, Types.VARCHAR, Types.VARCHAR});
	}

	public List getOneContentList(String subjectNum, int year, int chasu, String content, User user) {

		return getSqlQuery().list("BRD.SELECT_SUBJECT_BOARD_ONE_LIST", user.getCompanyId(),  subjectNum, year, chasu);
	}
	
    public String getFileContentType(int fileNum, int seqNum) {
		
		return getSqlQuery().queryForObject("BRD.GET_FILE_CONTENT_TYPE",  
				 new Object[]{fileNum, seqNum}, new int[]{Types.NUMERIC, Types.NUMERIC}, String.class);
	}


	public String getFileContentLength(int fileNum, int seqNum) {

		return getSqlQuery().queryForObject("BRD.GET_FILE_CONTENT_LENGTH",
				 new Object[]{fileNum, seqNum}, new int[]{Types.NUMERIC, Types.NUMERIC}, String.class);
	}


	public InputStream getInputStream(int fileNum, int seqNum) {

		return getSqlQuery().queryForObject("BRD.GET_FILE_DATA", 
				 new Object[]{fileNum, seqNum}, 
				 new int[]{Types.NUMERIC, Types.NUMERIC}, 
				 architecture.ee.jdbc.sqlquery.SqlQueryHelper.getInputStreamRowMapper());
	}


	public String getFileName(int fileNum, int seqNum) {

		return getSqlQuery().queryForObject("BRD.GET_FILE_NAME",  
				new Object[]{fileNum, seqNum}, 
				new int[]{Types.NUMERIC, Types.NUMERIC}, 
				String.class);
	}


	public long getMaxFileNum() {
		
		return this.getMaxValueIncrementer().nextLongValue("FILE");
	}
	
	public int maxBoardNum(String boardCode, long companyId) {

		return getSqlQuery().queryForObject("BRD.GET_BOARD_NUM", 
				new Object[]{boardCode}, 
				new int[]{Types.VARCHAR}, 
				Integer.class);
	}

	public int insertFile(long companyId, long fileNum, String fileName, long fileSize, InputStream file, String contentType, long userId) {
		
		SqlQueryHelper helper = new SqlQueryHelper(getLobHandler());
		helper.lob(file, (int)fileSize);
		
		return getSqlQuery().update("BRD.INSERT_FILE", 
				new Object[]{fileNum, fileNum, fileName, fileName, fileSize, helper.values()[0], contentType, userId}, 
				new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.BLOB, Types.VARCHAR, Types.NUMERIC});
	}

	public void fileNumUpdate(long companyId, String boardCode, int boardNum, long fileNum) {

		getSqlQuery().update("BRD.UPDATE_BOARD_FILE_NUM", fileNum, boardCode, boardNum);
	}


	public int fileDelete(int fileNum, int seqNum) {

		return getSqlQuery().update("BRD.DELETE_FILE", fileNum, seqNum);
	
	}

	public int updateBoard(String boardTittle, String boardContent,
			String actSdate, String actEdate, String noticeFlag, long userId, String boardCode,
			String boardNum) {
		// TODO Auto-generated method stub
		SqlQueryHelper helper = new SqlQueryHelper(getLobHandler());
		helper.lob(boardContent);
		
		getSqlQuery().update("BRD.UPDATE_BOARD_CONTENT_NULL", boardCode, boardNum);
		
		return getSqlQuery().update("BRD.UPDATE_BOARD", new Object[]{boardTittle, helper.values()[0], actSdate, actEdate, noticeFlag, userId, boardCode, boardNum}, 
				 new int[]{Types.VARCHAR, Types.CLOB, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC});
	}

	public int getBoardFileNum(long companyId, String boardCode, String boardNum)  {
		
		int result = 0; 
		try{
			result = getSqlQuery().queryForObject("BRD.GET_BOARD_FILE_NUM", new Object[]{boardCode, boardNum},
                    	new int[]{Types.VARCHAR, Types.NUMERIC}, Integer.class);
		}catch(Exception e){
			log.error(e);
		}

		return result; 
	}
	
	
}
