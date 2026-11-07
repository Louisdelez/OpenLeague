package com.riotgames.pvpnet.tracker.model
{
   import com.riotgames.util.json.jsonEncode;
   import flash.utils.getQualifiedClassName;
   
   public dynamic class RiotDradisRecord
   {
      
      private static const DRADIS_UNAUTHENTICATED_MESSAGE:String = "unauthedclient";
      
      private static const DRADIS_AUTHENTICATED_MESSAGE:String = "authedclient";
      
      private static const DRADIS_CLIENT_TYPE:String = "air";
      
      private static const MESSAGE_TYPE_PREFIX:String = "pvpnet_";
      
      public var app:String;
      
      public var region:String;
      
      public var session_id:String;
      
      public var send_probability:Number;
      
      public var client_version:String;
      
      public var timestamp:Number;
      
      public function RiotDradisRecord(param1:String, param2:String, param3:String, param4:Number, param5:String, param6:String, param7:Number, param8:Number, param9:Object, param10:String, param11:String, param12:String, param13:String, param14:String = null, param15:Boolean = false)
      {
         super();
         this.init(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15);
      }
      
      public function init(param1:String, param2:String, param3:String, param4:Number, param5:String, param6:String, param7:Number, param8:Number, param9:Object, param10:String, param11:String, param12:String, param13:String, param14:String = null, param15:Boolean = false) : void
      {
         this.app = DRADIS_CLIENT_TYPE;
         var _loc16_:Date = new Date();
         this.timestamp = _loc16_.getTime();
         this.composeContent_buildMessageType(param1);
         if(param2 != null)
         {
            this.region = param2;
         }
         if(param3 != null)
         {
            this.session_id = param3;
         }
         if(param10 != null)
         {
            this.os_type = param10;
         }
         if(param11 != null)
         {
            this.os_version = param11;
         }
         if(param12 != null)
         {
            this.client_language = param12;
         }
         if(param13 != null && param13 != "")
         {
            this.client_ip = param13;
         }
         if(param14 != null && param14 != "")
         {
            this.client_ip2 = param14;
         }
         if(!isNaN(param4))
         {
            this.send_probability = param4;
         }
         if(param6 != null)
         {
            this.client_version = param6;
         }
         if(!isNaN(param8))
         {
            this.summoner_level = param8;
         }
         if(!isNaN(param7))
         {
            this.summoner_id = param7;
         }
         if(param15)
         {
            this.engineer_debug = param15;
         }
         if(param5 != null)
         {
            this.gas_auth_token = "0";
            this.auth_state = DRADIS_AUTHENTICATED_MESSAGE;
            this.account_id = param5;
         }
         else
         {
            this.auth_state = DRADIS_UNAUTHENTICATED_MESSAGE;
         }
         this.explodeData(param9);
      }
      
      public function toJSONString(param1:Boolean = false) : String
      {
         var propName:String = null;
         var encodedArray:Array = null;
         var prettyPrint:Boolean = param1;
         var encodedData:String = null;
         try
         {
            encodedData = jsonEncode(this);
         }
         catch(encodingError:Error)
         {
            this.data = "JSON Encoding Error: " + encodingError.toString();
            for(propName in this)
            {
               if(propName.indexOf("data_") == 0)
               {
                  delete this[propName];
               }
            }
            encodedData = jsonEncode(this);
         }
         if(prettyPrint)
         {
            encodedData = encodedData.split("{").join("");
            encodedData = encodedData.split("}").join("");
            encodedArray = encodedData.split(",");
            encodedArray.sort();
            encodedData = "{\r\t" + encodedArray.join(",\r\t") + "\r}";
         }
         return encodedData;
      }
      
      protected function composeContent_buildMessageType(param1:String) : void
      {
         this.messageType = MESSAGE_TYPE_PREFIX + param1.split(/[^a-zA-Z0-9_]/).join("_");
      }
      
      protected function explodeData(param1:Object) : void
      {
         var propName:String = null;
         var payloadData:Object = param1;
         if(!payloadData || getQualifiedClassName(payloadData) != getQualifiedClassName(new Object()))
         {
            this.data = payloadData;
         }
         else
         {
            try
            {
               for(propName in payloadData)
               {
                  this["data_" + propName] = payloadData[propName];
               }
            }
            catch(e:Error)
            {
               this.data = "JSON encoding error during explode";
            }
         }
      }
   }
}

