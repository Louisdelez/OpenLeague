package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import flash.geom.Point;
   
   public interface IKudosDialog extends ICancelableDialog
   {
      
      function display() : void;
      
      function setData(param1:Number, param2:Number, param3:String, param4:Number, param5:Point = null) : void;
      
      function initializeBlixResources() : void;
   }
}

