package kr.podosoft.ws.service.common;

import architecture.ee.exception.ApplicationException;

public class CommonException extends ApplicationException {

	private static final long serialVersionUID = -77198998794544723L;

	public CommonException() {
		super();
	}

	public CommonException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public CommonException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public CommonException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public CommonException(int errorCode) {
		super(errorCode);
	}

	public CommonException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public CommonException(String msg) {
		super(msg);
	}

	public CommonException(Throwable cause) {
		super(cause);
	}
}
