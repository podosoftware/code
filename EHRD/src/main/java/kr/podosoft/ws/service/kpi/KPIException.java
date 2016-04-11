/**
 * @author ReeSSang
 * @version 
 * @since 2014. 4. 24.
 */
package kr.podosoft.ws.service.kpi;

import architecture.ee.exception.ApplicationException;

/**
 * <br/>
 * 
 * @author sylee
 * @version 1.0
 * @since 2014. 4. 24.
 */
public class KPIException extends ApplicationException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4520574534753651359L;

	public KPIException() {
		super();
	}

	public KPIException(int errorCode, String msg, Throwable cause) {
		super(errorCode, msg, cause);
	}

	public KPIException(int errorCode, String msg) {
		super(errorCode, msg);
	}

	public KPIException(int errorCode, Throwable cause) {
		super(errorCode, cause);
	}

	public KPIException(int errorCode) {
		super(errorCode);
	}

	public KPIException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public KPIException(String msg) {
		super(msg);
	}

	public KPIException(Throwable cause) {
		super(cause);
	}
}
