package com.riotgames.pvpnet.navigation
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.object.clone;
   import com.riotgames.util.logging.getLogger;
   import flash.net.URLVariables;
   import flash.net.registerClassAlias;
   import mx.logging.ILogger;
   
   public class NavigationClient implements IDestructible
   {
      
      private var _pathSection:String;
      
      private var _enabled:Boolean;
      
      private var _parameters:URLVariables = new URLVariables();
      
      private var _pathChanged:Signal = new Signal();
      
      private var _path:String = "";
      
      private var logger:ILogger = getLogger(this);
      
      private var _depth:int = -1;
      
      private var _parametersChanged:Signal = new Signal();
      
      private var handlingNavigationPathChange:Boolean;
      
      public function NavigationClient()
      {
         super();
         registerClassAlias("flash.net.URLVariables",URLVariables);
      }
      
      public function destroy() : void
      {
         NavigationManager.getPathChanged().remove(this.refreshPathSection);
         this._pathChanged.removeAll();
         this._parametersChanged.removeAll();
      }
      
      public function getEnabled() : Boolean
      {
         return this._enabled;
      }
      
      public function getDepth() : int
      {
         return this._depth;
      }
      
      public function setParameter(param1:String, param2:String) : void
      {
         var _loc3_:URLVariables = clone(this._parameters);
         if(param2 == null)
         {
            delete this._parameters[param1];
         }
         else
         {
            this._parameters[param1] = param2;
         }
         this.refreshNavigationPath();
         this._parametersChanged.dispatch(this,_loc3_,this._parameters);
      }
      
      public function setDepth(param1:int) : void
      {
         if(this._depth == param1)
         {
            return;
         }
         this._depth = param1;
         this.refreshPathSection();
      }
      
      private function refreshNavigationPath() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         if(this.handlingNavigationPathChange)
         {
            return;
         }
         for(_loc2_ in this._parameters)
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            this._pathSection = this._path + "||" + this._parameters.toString();
         }
         else
         {
            this._pathSection = this._path;
         }
         var _loc3_:Array = NavigationManager.getPathSplit();
         if(_loc3_.length <= this._depth)
         {
            _loc3_.length = this._depth + 1;
         }
         _loc3_[this._depth] = this._pathSection;
         NavigationManager.navigate("/" + _loc3_.join("/"));
      }
      
      public function getPath() : String
      {
         return this._path;
      }
      
      private function refreshPathSection() : void
      {
         if(!this._enabled)
         {
            return;
         }
         if(this._depth == -1)
         {
            return;
         }
         var _loc1_:Array = NavigationManager.getPathSplit();
         this.handlingNavigationPathChange = true;
         var _loc2_:String = this._depth >= _loc1_.length ? "" : _loc1_[this._depth];
         this.setPathSection(_loc2_);
         this.handlingNavigationPathChange = false;
      }
      
      public function getPathChanged() : ISignal
      {
         return this._pathChanged;
      }
      
      public function setParameters(param1:URLVariables) : void
      {
         if(param1 == null)
         {
            param1 = new URLVariables();
         }
         var _loc2_:URLVariables = this._parameters;
         if(_loc2_.toString() == param1.toString())
         {
            return;
         }
         this._parameters = param1;
         this.refreshNavigationPath();
         this._parametersChanged.dispatch(this,_loc2_,this._parameters);
      }
      
      public function getParameters() : URLVariables
      {
         return this._parameters;
      }
      
      public function getParametersChanged() : ISignal
      {
         return this._parametersChanged;
      }
      
      public function setPath(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         var _loc2_:String = this._path;
         if(_loc2_ == param1)
         {
            return;
         }
         this._path = param1;
         this.refreshNavigationPath();
         this._pathChanged.dispatch(this,_loc2_,this._path);
      }
      
      public function getParameter(param1:String) : String
      {
         return this._parameters[param1];
      }
      
      private function setPathSection(param1:String) : void
      {
         var split:Array;
         var parametersStr:String = null;
         var pathStr:String = null;
         var parameters:URLVariables = null;
         var value:String = param1;
         if(this._pathSection == value)
         {
            return;
         }
         this._pathSection = value;
         split = this._pathSection.split("||");
         if(split.length >= 2)
         {
            parametersStr = split[1];
         }
         if(split.length >= 1)
         {
            pathStr = split[0];
         }
         if(Boolean(parametersStr))
         {
            try
            {
               parameters = new URLVariables(parametersStr);
            }
            catch(error:Error)
            {
               logger.warn("Navigation path had incorrectly formatted parameters: " + _pathSection);
            }
            this.setParameters(parameters);
         }
         else
         {
            this.setParameters(null);
         }
         this.setPath(pathStr);
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this._enabled = param1;
         if(this._enabled)
         {
            NavigationManager.getPathChanged().add(this.refreshPathSection);
            this.refreshPathSection();
         }
         else
         {
            NavigationManager.getPathChanged().remove(this.refreshPathSection);
         }
      }
   }
}

