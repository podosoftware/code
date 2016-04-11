package kr.podosoft.ws.service.brd;

import architecture.ee.exception.ApplicationException;

public class BRDException extends ApplicationException {

	private static final long serialVersionUID = 2948533494030890871L;

	public BRDException() {
		super();
	}
 
	public BRDException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public BRDException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public BRDException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public BRDException(int errorCode) {
		super(errorCode);
	}

	public BRDException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public BRDException(String msg) {
		super(msg);
	}

	public BRDException(Throwable cause) {
		super(cause);
	}

}
