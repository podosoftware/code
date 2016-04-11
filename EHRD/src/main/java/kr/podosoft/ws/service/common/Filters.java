package kr.podosoft.ws.service.common;

public class Filters {
	/**
	 *
	 * @author  
	 * @version 
	 */
	private String field;
    private String operator;
    private String value;

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return "Filters [field=" + field + ", operator=" + operator + ", value=" + value + "]";
    }
}
