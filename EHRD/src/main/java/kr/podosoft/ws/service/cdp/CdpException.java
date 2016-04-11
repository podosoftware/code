package kr.podosoft.ws.service.cdp;

import architecture.ee.exception.ApplicationException;
public class CdpException extends ApplicationException {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8346492562846290182L;

	public CdpException() {
		super();
	}

	public CdpException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public CdpException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public CdpException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public CdpException(int errorCode) {
		super(errorCode);
	}

	public CdpException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public CdpException(String msg) {
		super(msg);
	}

	public CdpException(Throwable cause) {
		super(cause);
	}

}
