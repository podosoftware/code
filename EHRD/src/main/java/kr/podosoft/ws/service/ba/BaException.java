package kr.podosoft.ws.service.ba;

import architecture.ee.exception.ApplicationException;

public class BaException extends ApplicationException {

	private static final long serialVersionUID = 7085367567193870852L;
	
	public BaException() {
		super();
	}
	
	public BaException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public BaException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public BaException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public BaException(int errorCode) {
		super(errorCode);
	}

	public BaException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public BaException(String msg) {
		super(msg);
	}

	public BaException(Throwable cause) {
		super(cause);
	}
}
