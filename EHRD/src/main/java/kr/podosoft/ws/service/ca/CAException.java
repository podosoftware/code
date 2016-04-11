package kr.podosoft.ws.service.ca;

import architecture.ee.exception.ApplicationException;
public class CAException extends ApplicationException {

	private static final long serialVersionUID = -7874315941063755882L;

	public CAException() {
		super();
	}

	public CAException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public CAException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public CAException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public CAException(int errorCode) {
		super(errorCode);
	}

	public CAException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public CAException(String msg) {
		super(msg);
	}

	public CAException(Throwable cause) {
		super(cause);
	}

}
