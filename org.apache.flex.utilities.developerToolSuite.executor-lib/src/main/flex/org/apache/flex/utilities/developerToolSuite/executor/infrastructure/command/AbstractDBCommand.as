/**
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
package org.apache.flex.utilities.developerToolSuite.executor.infrastructure.command {
    import flash.data.SQLResult;
    import flash.data.SQLStatement;
    import flash.errors.SQLError;

    import mx.logging.ILogger;
    import mx.utils.ObjectUtil;

    import org.apache.flex.utilities.developerToolSuite.executor.application.database.ApplicationDB;
    import org.apache.flex.utilities.developerToolSuite.executor.application.util.LogUtil;

    public class AbstractDBCommand {

        protected var log:ILogger;

        [MessageDispatcher]
        public var dispatch:Function;

        [Inject]
        public var db:ApplicationDB;

        public var callback:Function;

        protected var sql:String;
        protected var stmt:SQLStatement = new SQLStatement();

        function AbstractDBCommand():void {
            log = LogUtil.getLogger(this);
        }

        protected function executeAsync():void {
            db.connect(prepareSql);
        }

        protected function prepareSql():void {
            stmt.text = sql;
            db.executeSqlStatement(stmt, result, error);
        }

        protected function result(result:SQLResult, terminateCommand:Boolean = true):void {
            var resultMessage:String = (result.data != null) ? ObjectUtil.toString(result.data) : result.rowsAffected + " affected row(s)";
            log.debug("Successfully executed DB Command: {0}", resultMessage);
            if (terminateCommand) {
                callback(new CommandCallBackResult(result));
            }
        }

        protected function error(error:SQLError, terminateCommand:Boolean = true):void {
            log.error("Error executing DB Command: {0}", ObjectUtil.toString(error));
            if (terminateCommand) {
                callback(new CommandCallBackError(error.message, error.detailID));
            }
        }
    }
}
