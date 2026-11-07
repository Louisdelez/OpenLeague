package com.riotgames.platform.gameclient.controllers
{
   public interface IViewController
   {
      
      function initialize() : void;
      
      function activate() : void;
      
      function cleanup() : void;
      
      function deactivate() : void;
   }
}

