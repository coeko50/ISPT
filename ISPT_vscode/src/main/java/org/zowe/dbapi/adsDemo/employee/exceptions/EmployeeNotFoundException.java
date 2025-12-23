package org.zowe.dbapi.adsDemo.employee.exceptions;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * An   application-specific exception. Defined here for convenience
 * as we don't have a real domain model or its associated business logic.
 */
@ResponseStatus(value = HttpStatus.NOT_FOUND, reason = "No such Employee")

public class EmployeeNotFoundException extends RuntimeException {
 
	/**
	 * Unique ID for Serialized object
	 */
	private static final long serialVersionUID = -8790211652911971729L;

	public EmployeeNotFoundException(String empId) {
		super(empId + " not found");
	}
}
