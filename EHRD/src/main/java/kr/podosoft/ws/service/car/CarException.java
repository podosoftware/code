package kr.podosoft.ws.service.car;

import architecture.ee.exception.ApplicationException;
public class CarException extends ApplicationException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public CarException() {
		super();
	}

	public CarException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public CarException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public CarException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public CarException(int errorCode) {
		super(errorCode);
	}

	public CarException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public CarException(String msg) {
		super(msg);
	}

	public CarException(Throwable cause) {
		super(cause);
	}

}
