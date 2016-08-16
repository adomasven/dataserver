<?
interface Zotero_IExternalUsers {
	/**
	 * Authenticate using data provided in the JSON POST request to /keys
	 * 
	 * Used to authenticate a user and generate an API key given user credentials. 
	 * A standard authentication method would query $data['username'] and $data['password']
	 * against a database or an external service.
	 * 
	 * @param array $data JSON in POST request body to /keys
	 * @return int an unique UserID to be associated with provided credentials
	 */
	public static function authenticate($data);
}
?>
