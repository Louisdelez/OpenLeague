package com.riotgames.platform.gameclient.module.rt.vo
{
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   
   public class ErrorMessageVO
   {
      
      private var _body:String;
      
      private var _title:String;
      
      public function ErrorMessageVO(param1:String = "", param2:String = "")
      {
         super();
         this.setBody(param1);
         if(param2 == "")
         {
            this.setTitle("ranked_team_error_header");
         }
         else
         {
            this.setTitle(param2);
         }
      }
      
      public function getTitle() : String
      {
         return this._title;
      }
      
      public function setTitle(param1:String, param2:Array = null) : void
      {
         this._title = RTResource.getString(param1,param2);
      }
      
      public function getBody() : String
      {
         return this._body;
      }
      
      public function setBody(param1:String, param2:Array = null) : void
      {
         this._body = RTResource.getString(param1,param2);
      }
   }
}

