package kr.podosoft.ws.service.mtr;

import architecture.ee.exception.ApplicationException;
public class MtrException extends ApplicationException {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8346492562846290182L;

	public MtrException() {
		super();
	}

	public MtrException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public MtrException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public MtrException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public MtrException(int errorCode) {
		super(errorCode);
	}

	public MtrException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public MtrException(String msg) {
		super(msg);
	}

	public MtrException(Throwable cause) {
		super(cause);
	}

}
