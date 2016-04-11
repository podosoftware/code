package kr.podosoft.ws.service.cam;

import architecture.ee.exception.ApplicationException;
public class CAMException extends ApplicationException {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8346492562846290182L;

	public CAMException() {
		super();
	}

	public CAMException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public CAMException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public CAMException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public CAMException(int errorCode) {
		super(errorCode);
	}

	public CAMException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public CAMException(String msg) {
		super(msg);
	}

	public CAMException(Throwable cause) {
		super(cause);
	}

}
