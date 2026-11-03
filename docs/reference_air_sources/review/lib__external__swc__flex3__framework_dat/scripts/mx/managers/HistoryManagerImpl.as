package mx.managers
{
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.utils.Dictionary;
   import mx.core.ApplicationGlobals;
   import mx.core.mx_internal;
   import mx.events.BrowserChangeEvent;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class HistoryManagerImpl implements IHistoryManager
   {
      
      private static var instance:IHistoryManager;
      
      private static var appID:String;
      
      private static var historyURL:String;
      
      private static var systemManager:ISystemManager;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const HANDSHAKE_INTERVAL:int = 500;
      
      private static const MAX_HANDSHAKE_TRIES:int = 100;
      
      private static const ID_NAME_SEPARATOR:String = "-";
      
      private static const NAME_VALUE_SEPARATOR:String = "=";
      
      private static const PROPERTY_SEPARATOR:String = "&";
      
      private var registeredObjects:Array = [];
      
      private var pendingQueryString:String;
      
      private var pendingStates:Object = {};
      
      private var registrationMap:Dictionary;
      
      public function HistoryManagerImpl()
      {
         var loaderInfo:LoaderInfo = null;
         var appURL:String = null;
         super();
         if(Boolean(instance))
         {
            throw new Error("Instance already exists.");
         }
         if(Boolean(appID))
         {
            return;
         }
         if(!ApplicationGlobals.application.historyManagementEnabled)
         {
            return;
         }
         if(Boolean(HistoryManagerGlobals.loaderInfo))
         {
            loaderInfo = HistoryManagerGlobals.loaderInfo;
         }
         else
         {
            loaderInfo = DisplayObject(systemManager).loaderInfo;
         }
         if(Boolean(HistoryManagerGlobals.loaderInfo))
         {
            appURL = HistoryManagerGlobals.loaderInfo.url;
         }
         else
         {
            appURL = DisplayObject(systemManager).loaderInfo.url;
         }
         appID = calcCRC(appURL);
         BrowserManager.getInstance().addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE,browserURLChangeHandler);
         BrowserManager.getInstance().initForHistoryManager();
      }
      
      public static function getInstance() : IHistoryManager
      {
         if(!instance)
         {
            systemManager = SystemManagerGlobals.topLevelSystemManagers[0];
            instance = new HistoryManagerImpl();
         }
         return instance;
      }
      
      public function registered() : void
      {
      }
      
      public function unregister(obj:IHistoryManagerClient) : void
      {
         if(!ApplicationGlobals.application.historyManagementEnabled)
         {
            return;
         }
         var index:int = -1;
         var n:int = int(registeredObjects.length);
         for(var i:int = 0; i < n; i++)
         {
            if(registeredObjects[i] == obj)
            {
               index = i;
               break;
            }
         }
         if(index >= 0)
         {
            registeredObjects.splice(index,1);
         }
         if(Boolean(obj) && Boolean(registrationMap))
         {
            delete registrationMap[obj];
         }
      }
      
      private function updateCRC(crc:uint, byte:uint) : uint
      {
         var xorFlag:Boolean = false;
         var poly:uint = 4129;
         var bitMask:uint = 128;
         for(var i:int = 0; i < 8; i++)
         {
            xorFlag = (crc & 0x8000) != 0;
            crc <<= 1;
            crc &= 65535;
            if((byte & bitMask) != 0)
            {
               crc++;
            }
            if(xorFlag)
            {
               crc ^= poly;
            }
            bitMask >>= 1;
         }
         return crc;
      }
      
      private function submitQuery() : void
      {
         if(Boolean(pendingQueryString))
         {
            BrowserManager.getInstance().setFragment(pendingQueryString);
            pendingQueryString = null;
            ApplicationGlobals.application.resetHistory = true;
         }
      }
      
      public function browserURLChangeHandler(event:BrowserChangeEvent) : void
      {
         var p:String = null;
         var crc:String = null;
         var nameValuePair:Array = null;
         var crclen:int = 0;
         var name:String = null;
         var value:Object = null;
         var registeredObject:IHistoryManagerClient = null;
         if(!ApplicationGlobals.application.historyManagementEnabled)
         {
            return;
         }
         var pieces:Array = event.url.split(PROPERTY_SEPARATOR);
         var stateVars:Object = {};
         var n:int = int(pieces.length);
         for(var i:int = 0; i < n; i++)
         {
            nameValuePair = pieces[i].split(NAME_VALUE_SEPARATOR);
            stateVars[nameValuePair[0]] = parseString(nameValuePair[1]);
         }
         var params:Object = {};
         for(p in stateVars)
         {
            crclen = p.indexOf(ID_NAME_SEPARATOR);
            if(crclen > -1)
            {
               crc = p.substr(0,crclen);
               name = p.substr(crclen + 1,p.length);
               value = stateVars[p];
               if(!params[crc])
               {
                  params[crc] = {};
               }
               params[crc][name] = value;
            }
         }
         n = int(registeredObjects.length);
         for(i = 0; i < n; i++)
         {
            registeredObject = registeredObjects[i];
            crc = getRegistrationInfo(registeredObject).crc;
            registeredObject.loadState(params[crc]);
            delete params[crc];
         }
         for(p in params)
         {
            pendingStates[p] = params[p];
         }
      }
      
      public function registerHandshake() : void
      {
      }
      
      private function getRegistrationInfo(obj:IHistoryManagerClient) : RegistrationInfo
      {
         return Boolean(registrationMap) ? registrationMap[obj] : null;
      }
      
      private function getPath(obj:IHistoryManagerClient) : String
      {
         return obj.toString();
      }
      
      public function load(stateVars:Object) : void
      {
      }
      
      private function depthCompare(a:Object, b:Object) : int
      {
         var regInfoA:RegistrationInfo = getRegistrationInfo(IHistoryManagerClient(a));
         var regInfoB:RegistrationInfo = getRegistrationInfo(IHistoryManagerClient(b));
         if(!regInfoA || !regInfoB)
         {
            return 0;
         }
         if(regInfoA.depth > regInfoB.depth)
         {
            return 1;
         }
         if(regInfoA.depth < regInfoB.depth)
         {
            return -1;
         }
         return 0;
      }
      
      public function register(obj:IHistoryManagerClient) : void
      {
         if(!ApplicationGlobals.application.historyManagementEnabled)
         {
            return;
         }
         unregister(obj);
         registeredObjects.push(obj);
         var path:String = getPath(obj);
         var crc:String = calcCRC(path);
         var depth:int = calcDepth(path);
         if(!registrationMap)
         {
            registrationMap = new Dictionary(true);
         }
         registrationMap[obj] = new RegistrationInfo(crc,depth);
         registeredObjects.sort(depthCompare);
         if(Boolean(pendingStates[crc]))
         {
            obj.loadState(pendingStates[crc]);
            delete pendingStates[crc];
         }
      }
      
      private function parseString(s:String) : Object
      {
         if(s == "true")
         {
            return true;
         }
         if(s == "false")
         {
            return false;
         }
         var i:int = parseInt(s);
         if(i.toString() == s)
         {
            return i;
         }
         var n:Number = parseFloat(s);
         if(n.toString() == s)
         {
            return n;
         }
         return s;
      }
      
      private function calcDepth(path:String) : int
      {
         return path.split(".").length;
      }
      
      public function loadInitialState() : void
      {
      }
      
      public function save() : void
      {
         var registeredObject:IHistoryManagerClient = null;
         var stateInfo:Object = null;
         var crc:String = null;
         var name:String = null;
         var value:Object = null;
         if(!ApplicationGlobals.application.historyManagementEnabled)
         {
            return;
         }
         var haveState:Boolean = false;
         var queryString:String = "app=" + appID;
         var n:int = int(registeredObjects.length);
         for(var i:int = 0; i < n; i++)
         {
            registeredObject = registeredObjects[i];
            stateInfo = registeredObject.saveState();
            crc = getRegistrationInfo(registeredObject).crc;
            for(name in stateInfo)
            {
               value = stateInfo[name];
               if(queryString.length > 0)
               {
                  queryString += PROPERTY_SEPARATOR;
               }
               queryString += crc;
               queryString += ID_NAME_SEPARATOR;
               queryString += escape(name);
               queryString += NAME_VALUE_SEPARATOR;
               queryString += escape(value.toString());
               haveState = true;
            }
         }
         if(haveState)
         {
            pendingQueryString = queryString;
            ApplicationGlobals.application.callLater(this.submitQuery);
         }
      }
      
      private function calcCRC(s:String) : String
      {
         var charCode:uint = 0;
         var loByte:uint = 0;
         var hiByte:uint = 0;
         var crc:uint = 65535;
         var n:int = s.length;
         for(var i:int = 0; i < n; i++)
         {
            charCode = s.charCodeAt(i);
            loByte = uint(charCode & 0xFF);
            hiByte = uint(charCode >> 8);
            if(hiByte != 0)
            {
               crc = updateCRC(crc,hiByte);
            }
            crc = updateCRC(crc,loByte);
         }
         crc = updateCRC(crc,0);
         crc = updateCRC(crc,0);
         return crc.toString(16);
      }
   }
}

import mx.core.mx_internal;

use namespace mx_internal;

class RegistrationInfo
{
   
   mx_internal static const VERSION:String = "3.5.0.12683";
   
   public var depth:int;
   
   public var crc:String;
   
   public function RegistrationInfo(crc:String, depth:int)
   {
      super();
      this.crc = crc;
      this.depth = depth;
   }
}
