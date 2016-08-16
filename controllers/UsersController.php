<?
/*
    ***** BEGIN LICENSE BLOCK *****
    
    This file is part of the Zotero Data Server.
    
    Copyright © 2016 Center for History and New Media
                     George Mason University, Fairfax, Virginia, USA
                     http://zotero.org
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.
    
    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    ***** END LICENSE BLOCK *****
*/
require('ApiController.php');

class UsersController extends ApiController {
	// DOCKERIZATION: respond with something more sensible.
	public function users() {
		$this->allowMethods(['GET', 'POST', 'DELETE']);
		
		if (!$this->apiVersion >= 3 || !Z_CONFIG::$CUSTOM_SETUP) {
			$this->e404();
		}

		if (!$this->permissions->isSuper()) {
			$this->e403();
		}
		
		if ($this->method == 'POST') {
			$json = json_decode($this->body, true);
			if (!$json) {
				$this->e400("$this->method data is not valid JSON");
			}
			if (!$json['username']) {
				$this->e400("JSON data must contain a 'username'");
			}
			// Create the user
			$userID = Zotero_ExternalUsers::authenticate($json);
			if ($userID) {
				Zotero_DB::beginTransaction();
				try {
					$libraryID = Zotero_Users::add($userID, $json['username']);
					$keyObj = new Zotero_Key;
					$keyObj->userID = $userID;
					$keyObj->name = "Auto-key";
					$keyObj->setPermission(0, 'group', true);
					$keyObj->setPermission(0, 'write', true);
					$keyObj->setPermission($libraryID, 'library', true);
					$keyObj->setPermission($libraryID, 'write', true);
					$keyObj->setPermission($libraryID, 'notes', true);
					$keyObj->save();
				}
				catch (Exception $e) {
					if ($e->getCode() == Z_ERROR_RESOURCE_EXISTS || $e->getCode() == Z_ERROR_KEY_NAME_TOO_LONG) {
						$this->e400($e->getMessage());
					}
					$this->handleException($e);
				}
				Zotero_DB::commit();
				$this->responseXML = $keyObj->toXML();
			} else {
				$this->e403("Could not authenticate user '{$json['username']}'");
			}
		}

		$this->end();
	}
}
