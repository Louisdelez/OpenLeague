package org.swizframework.core
{
   public class SwizConfig implements ISwizConfig
   {
      
      public static const GLOBAL_DISPATCHER:String = "global";
      
      public static const LOCAL_DISPATCHER:String = "local";
      
      protected static const WILDCARD_PACKAGE:RegExp = /\A(.*)(\.\**)\Z/;
      
      protected var _strict:Boolean = true;
      
      protected var _setUpEventType:String = "addedToStage";
      
      protected var _setUpEventPriority:int = 50;
      
      protected var _setUpEventPhase:uint = 1;
      
      protected var _tearDownEventType:String = "removedFromStage";
      
      protected var _tearDownEventPriority:int = 50;
      
      protected var _tearDownEventPhase:uint = 1;
      
      protected var _eventPackages:Array = [];
      
      protected var _viewPackages:Array = [];
      
      protected var _defaultFaultHandler:Function;
      
      protected var _defaultDispatcher:String = "global";
      
      public function SwizConfig()
      {
         super();
      }
      
      public function get strict() : Boolean
      {
         return this._strict;
      }
      
      public function set strict(value:Boolean) : void
      {
         this._strict = value;
      }
      
      public function get setUpEventType() : String
      {
         return this._setUpEventType;
      }
      
      public function set setUpEventType(value:String) : void
      {
         this._setUpEventType = value;
      }
      
      public function get setUpEventPriority() : int
      {
         return this._setUpEventPriority;
      }
      
      public function set setUpEventPriority(value:int) : void
      {
         this._setUpEventPriority = value;
      }
      
      public function get setUpEventPhase() : uint
      {
         return this._setUpEventPhase;
      }
      
      public function set setUpEventPhase(value:uint) : void
      {
         this._setUpEventPhase = value;
      }
      
      public function get tearDownEventType() : String
      {
         return this._tearDownEventType;
      }
      
      public function set tearDownEventType(value:String) : void
      {
         this._tearDownEventType = value;
      }
      
      public function get tearDownEventPriority() : int
      {
         return this._tearDownEventPriority;
      }
      
      public function set tearDownEventPriority(value:int) : void
      {
         this._tearDownEventPriority = value;
      }
      
      public function get tearDownEventPhase() : uint
      {
         return this._tearDownEventPhase;
      }
      
      public function set tearDownEventPhase(value:uint) : void
      {
         this._tearDownEventPhase = value;
      }
      
      public function get eventPackages() : Array
      {
         return this._eventPackages;
      }
      
      public function set eventPackages(value:*) : void
      {
         this.setEventPackages(value);
      }
      
      public function get viewPackages() : Array
      {
         return this._viewPackages;
      }
      
      public function set viewPackages(value:*) : void
      {
         this.setViewPackages(value);
      }
      
      public function get defaultFaultHandler() : Function
      {
         return this._defaultFaultHandler;
      }
      
      public function set defaultFaultHandler(faultHandler:Function) : void
      {
         this._defaultFaultHandler = faultHandler;
      }
      
      public function get defaultDispatcher() : String
      {
         return this._defaultDispatcher;
      }
      
      public function set defaultDispatcher(dispatcher:String) : void
      {
         this._defaultDispatcher = dispatcher;
      }
      
      protected function setEventPackages(value:*) : void
      {
         this._eventPackages = this.parsePackageValue(value);
      }
      
      protected function setViewPackages(value:*) : void
      {
         this._viewPackages = this.parsePackageValue(value);
      }
      
      protected function parsePackageValue(value:*) : Array
      {
         if(value == null)
         {
            return [];
         }
         if(value is Array)
         {
            return this.parsePackageNames(value as Array);
         }
         if(value is String)
         {
            return this.parsePackageNames(value.replace(/\ /g,"").split(","));
         }
         throw new Error("Package specified using unknown type. Supported types are Array or String.");
      }
      
      protected function parsePackageNames(packageNames:Array) : Array
      {
         var packageName:String = null;
         var parsedPackageNames:Array = [];
         for each(packageName in packageNames)
         {
            parsedPackageNames.push(this.parsePackageName(packageName));
         }
         return parsedPackageNames;
      }
      
      protected function parsePackageName(packageName:String) : String
      {
         var match:Object = WILDCARD_PACKAGE.exec(packageName);
         if(Boolean(match))
         {
            return match[1];
         }
         return packageName;
      }
   }
}

