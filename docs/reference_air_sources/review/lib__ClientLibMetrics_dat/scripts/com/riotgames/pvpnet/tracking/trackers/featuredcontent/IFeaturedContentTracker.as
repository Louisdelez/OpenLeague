package com.riotgames.pvpnet.tracking.trackers.featuredcontent
{
   public interface IFeaturedContentTracker
   {
      
      function setContentId(param1:String) : void;
      
      function exitedBook(param1:String) : void;
      
      function enteredBook(param1:String) : void;
      
      function closedBook(param1:String, param2:String, param3:Boolean) : void;
      
      function clickedButton(param1:String, param2:String) : void;
      
      function mouseOutButton(param1:String, param2:String) : void;
      
      function mouseOverButton(param1:String, param2:String) : void;
      
      function exitedPage(param1:String) : void;
      
      function completedPage(param1:String) : void;
      
      function enteredPage(param1:String) : void;
      
      function setPages(param1:Array) : void;
      
      function setInMatchMakingQueue(param1:Boolean) : void;
   }
}

