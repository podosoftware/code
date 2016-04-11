package kr.podosoft.ws.service.common;

import java.util.List;

public class Filter {
	/**
	 *
	 * @author  
	 * @version 
	 */
	private List<Filters> filters;
    private String logic;

    public List<Filters> getFilters() {
        return filters;
    }

    public void setFilters(List<Filters> filters) {
        this.filters = filters;
    }

    public String getLogic() {
        return logic;
    }

    public void setLogic(String logic) {
        this.logic = logic;
    }

    @Override
    public String toString() {
        return "Filter [filters=" + filters + ", logic=" + logic + "]";
    }
}
