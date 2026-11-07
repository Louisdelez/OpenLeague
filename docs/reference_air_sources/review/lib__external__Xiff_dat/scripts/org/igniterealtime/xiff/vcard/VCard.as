package org.igniterealtime.xiff.vcard
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.xml.XMLNode;
   import mx.events.PropertyChangeEvent;
   import mx.utils.Base64Decoder;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.data.vcard.VCardExtension;
   import org.igniterealtime.xiff.events.VCardEvent;
   
   public class VCard extends EventDispatcher
   {
      
      private static var requestTimer:Timer;
      
      private static var cache:Object = {};
      
      private static var requestQueue:Array = [];
      
      private static var cacheFlushTimer:Timer = new Timer(21600000,0);
      
      private var _loader:Loader;
      
      private var contact:RosterItemVO;
      
      private var _105221jid:UnescapedJID;
      
      private var _132835675firstName:String;
      
      private var _818219584middleName:String;
      
      private var _1459599807lastName:String;
      
      private var _70690926nickname:String;
      
      private var _96619420email:String;
      
      private var _1330852282fullName:String;
      
      private var _950484093company:String;
      
      private var _848184146department:String;
      
      private var _110371416title:String;
      
      private var _116079url:String;
      
      private var _5014345workPostalCode:String;
      
      private var _310026416workStateProvince:String;
      
      private var _1299282013workAddress:String;
      
      private var _806241093workCountry:String;
      
      private var _34333724workCity:String;
      
      private var _544819095homePostalCode:String;
      
      private var _655724610homeStateProvince:String;
      
      private var _1534405099homeAddress:String;
      
      private var _571118007homeCountry:String;
      
      private var _486704406homeCity:String;
      
      private var _2032596810workVoiceNumber:String;
      
      private var _601193291workFaxNumber:String;
      
      private var _156166885workPagerNumber:String;
      
      private var _800129340workCellNumber:String;
      
      private var _1586674876homeVoiceNumber:String;
      
      private var _1078787751homeFaxNumber:String;
      
      private var _602088819homePagerNumber:String;
      
      private var _1339934090homeCellNumber:String;
      
      private var _1097519099loaded:Boolean = false;
      
      private var _avatar:DisplayObject;
      
      private var _imageBytes:ByteArray;
      
      public function VCard()
      {
         super();
      }
      
      public static function getVCard(param1:XMPPConnection, param2:RosterItemVO) : VCard
      {
         var jidString:String;
         var cachedCard:VCard;
         var vcard:VCard = null;
         var con:XMPPConnection = param1;
         var user:RosterItemVO = param2;
         if(!cacheFlushTimer.running)
         {
            cacheFlushTimer.start();
            cacheFlushTimer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
            {
               var _loc3_:VCard = null;
               var _loc2_:Object = cache;
               cache = {};
               for each(_loc3_ in _loc2_)
               {
                  pushRequest(con,vcard);
               }
            });
         }
         jidString = user.jid.toString();
         cachedCard = cache[jidString];
         if(Boolean(cachedCard))
         {
            return cachedCard;
         }
         vcard = new VCard();
         vcard.contact = user;
         cache[jidString] = vcard;
         pushRequest(con,vcard);
         return vcard;
      }
      
      private static function pushRequest(param1:XMPPConnection, param2:VCard) : void
      {
         if(!requestTimer)
         {
            requestTimer = new Timer(1,1);
            requestTimer.addEventListener(TimerEvent.TIMER_COMPLETE,sendRequest);
         }
         requestQueue.push({
            "connection":param1,
            "card":param2
         });
         requestTimer.reset();
         requestTimer.start();
      }
      
      private static function sendRequest(param1:TimerEvent) : void
      {
         if(requestQueue.length == 0)
         {
            return;
         }
         var _loc2_:Object = requestQueue.pop();
         var _loc3_:XMPPConnection = _loc2_.connection;
         var _loc4_:VCard = _loc2_.card;
         var _loc5_:RosterItemVO = _loc4_.contact;
         var _loc6_:IQ = new IQ(_loc5_.jid.escaped,IQ.GET_TYPE);
         _loc4_.jid = _loc5_.jid;
         _loc6_.callbackName = "handleVCard";
         _loc6_.callbackScope = _loc4_;
         _loc6_.addExtension(new VCardExtension());
         _loc3_.send(_loc6_);
         requestTimer.reset();
         requestTimer.start();
      }
      
      public function saveVCard(param1:XMPPConnection, param2:RosterItemVO) : void
      {
         var _loc6_:XMLNode = null;
         var _loc7_:XMLNode = null;
         var _loc8_:XMLNode = null;
         var _loc9_:XMLNode = null;
         var _loc10_:XMLNode = null;
         var _loc11_:XMLNode = null;
         var _loc12_:XMLNode = null;
         var _loc13_:XMLNode = null;
         var _loc14_:XMLNode = null;
         var _loc15_:XMLNode = null;
         var _loc16_:XMLNode = null;
         var _loc17_:XMLNode = null;
         var _loc18_:XMLNode = null;
         var _loc19_:XMLNode = null;
         var _loc20_:XMLNode = null;
         var _loc21_:XMLNode = null;
         var _loc22_:XMLNode = null;
         var _loc23_:XMLNode = null;
         var _loc24_:XMLNode = null;
         var _loc25_:XMLNode = null;
         var _loc26_:XMLNode = null;
         var _loc27_:XMLNode = null;
         var _loc28_:XMLNode = null;
         var _loc29_:XMLNode = null;
         var _loc30_:XMLNode = null;
         var _loc31_:XMLNode = null;
         var _loc32_:XMLNode = null;
         var _loc33_:XMLNode = null;
         var _loc34_:XMLNode = null;
         var _loc35_:XMLNode = null;
         var _loc36_:XMLNode = null;
         var _loc37_:XMLNode = null;
         var _loc38_:XMLNode = null;
         var _loc39_:XMLNode = null;
         var _loc40_:XMLNode = null;
         var _loc41_:XMLNode = null;
         var _loc42_:XMLNode = null;
         var _loc43_:XMLNode = null;
         var _loc44_:XMLNode = null;
         var _loc45_:XMLNode = null;
         var _loc46_:XMLNode = null;
         var _loc3_:IQ = new IQ(null,IQ.SET_TYPE,XMPPStanza.generateID("save_vcard_"),null,this,this._vCardSent);
         var _loc4_:VCardExtension = new VCardExtension();
         var _loc5_:XMLNode = _loc4_.getNode();
         if(Boolean(this.firstName) || Boolean(this.middleName) || Boolean(this.lastName))
         {
            _loc6_ = new XMLNode(1,"N");
            if(Boolean(this.firstName))
            {
               _loc7_ = new XMLNode(1,"GIVEN");
               _loc7_.appendChild(new XMLNode(3,this.firstName));
               _loc6_.appendChild(_loc7_);
            }
            if(Boolean(this.middleName))
            {
               _loc8_ = new XMLNode(1,"MIDDLE");
               _loc8_.appendChild(new XMLNode(3,this.middleName));
               _loc6_.appendChild(_loc8_);
            }
            if(Boolean(this.lastName))
            {
               _loc9_ = new XMLNode(1,"FAMILY");
               _loc9_.appendChild(new XMLNode(3,this.lastName));
               _loc6_.appendChild(_loc9_);
            }
            _loc5_.appendChild(_loc6_);
         }
         if(Boolean(this.fullName))
         {
            _loc10_ = new XMLNode(1,"FN");
            _loc10_.appendChild(new XMLNode(3,this.fullName));
            _loc5_.appendChild(_loc10_);
         }
         if(Boolean(this.nickname))
         {
            _loc11_ = new XMLNode(1,"NICKNAME");
            _loc11_.appendChild(new XMLNode(3,this.nickname));
            _loc5_.appendChild(_loc11_);
         }
         if(Boolean(this.email))
         {
            _loc12_ = new XMLNode(1,"EMAIL");
            _loc12_.appendChild(new XMLNode(3,"INTERNET"));
            _loc12_.appendChild(new XMLNode(3,"PREF"));
            _loc13_ = new XMLNode(1,"USERID");
            _loc13_.appendChild(new XMLNode(3,this.email));
            _loc12_.appendChild(_loc13_);
            _loc5_.appendChild(_loc12_);
         }
         if(Boolean(this.company) || Boolean(this.department))
         {
            _loc14_ = new XMLNode(1,"ORG");
            if(Boolean(this.company))
            {
               _loc15_ = new XMLNode(1,"ORGNAME");
               _loc15_.appendChild(new XMLNode(3,this.company));
               _loc14_.appendChild(_loc15_);
            }
            if(Boolean(this.department))
            {
               _loc16_ = new XMLNode(1,"ORGUNIT");
               _loc16_.appendChild(new XMLNode(3,this.department));
               _loc14_.appendChild(_loc16_);
            }
            _loc5_.appendChild(_loc14_);
         }
         if(Boolean(this.title))
         {
            _loc17_ = new XMLNode(1,"TITLE");
            _loc17_.appendChild(new XMLNode(3,this.title));
            _loc5_.appendChild(_loc17_);
         }
         if(Boolean(this.url))
         {
            _loc18_ = new XMLNode(1,"URL");
            _loc18_.appendChild(new XMLNode(3,this.url));
            _loc5_.appendChild(_loc18_);
         }
         if(Boolean(this.workAddress) || Boolean(this.workCity) || Boolean(this.workCountry) || Boolean(this.workPostalCode) || Boolean(this.workStateProvince))
         {
            _loc19_ = new XMLNode(1,"ADR");
            _loc19_.appendChild(new XMLNode(1,"WORK"));
            if(Boolean(this.workAddress))
            {
               _loc20_ = new XMLNode(1,"STREET");
               _loc20_.appendChild(new XMLNode(3,this.workAddress));
               _loc19_.appendChild(_loc20_);
            }
            if(Boolean(this.workCity))
            {
               _loc21_ = new XMLNode(1,"LOCALITY");
               _loc21_.appendChild(new XMLNode(3,this.workCity));
               _loc19_.appendChild(_loc21_);
            }
            if(Boolean(this.workCountry))
            {
               _loc22_ = new XMLNode(1,"CTRY");
               _loc22_.appendChild(new XMLNode(3,this.workCountry));
               _loc19_.appendChild(_loc22_);
            }
            if(Boolean(this.workPostalCode))
            {
               _loc23_ = new XMLNode(1,"PCODE");
               _loc23_.appendChild(new XMLNode(3,this.workPostalCode));
               _loc19_.appendChild(_loc23_);
            }
            if(Boolean(this.workStateProvince))
            {
               _loc24_ = new XMLNode(1,"REGION");
               _loc24_.appendChild(new XMLNode(3,this.workStateProvince));
               _loc19_.appendChild(_loc24_);
            }
            _loc5_.appendChild(_loc19_);
         }
         if(Boolean(this.homeAddress) || Boolean(this.homeCity) || Boolean(this.homeCountry) || Boolean(this.homePostalCode) || Boolean(this.homeStateProvince))
         {
            _loc25_ = new XMLNode(1,"ADR");
            _loc25_.appendChild(new XMLNode(1,"HOME"));
            if(Boolean(this.homeAddress))
            {
               _loc26_ = new XMLNode(1,"STREET");
               _loc26_.appendChild(new XMLNode(3,this.homeAddress));
               _loc25_.appendChild(_loc26_);
            }
            if(Boolean(this.homeCity))
            {
               _loc27_ = new XMLNode(1,"LOCALITY");
               _loc27_.appendChild(new XMLNode(3,this.homeCity));
               _loc25_.appendChild(_loc27_);
            }
            if(Boolean(this.homeCountry))
            {
               _loc28_ = new XMLNode(1,"CTRY");
               _loc28_.appendChild(new XMLNode(3,this.homeCountry));
               _loc25_.appendChild(_loc28_);
            }
            if(Boolean(this.homePostalCode))
            {
               _loc29_ = new XMLNode(1,"PCODE");
               _loc29_.appendChild(new XMLNode(3,this.homePostalCode));
               _loc25_.appendChild(_loc29_);
            }
            if(Boolean(this.homeStateProvince))
            {
               _loc30_ = new XMLNode(1,"REGION");
               _loc30_.appendChild(new XMLNode(3,this.homeStateProvince));
               _loc25_.appendChild(_loc30_);
            }
            _loc5_.appendChild(_loc25_);
         }
         if(Boolean(this.workCellNumber))
         {
            _loc31_ = new XMLNode(1,"TEL");
            _loc31_.appendChild(new XMLNode(1,"WORK"));
            _loc31_.appendChild(new XMLNode(1,"CELL"));
            _loc32_ = new XMLNode(1,"NUMBER");
            _loc32_.appendChild(new XMLNode(3,this.workCellNumber));
            _loc31_.appendChild(_loc32_);
            _loc5_.appendChild(_loc31_);
         }
         if(Boolean(this.workFaxNumber))
         {
            _loc33_ = new XMLNode(1,"TEL");
            _loc33_.appendChild(new XMLNode(1,"WORK"));
            _loc33_.appendChild(new XMLNode(1,"FAX"));
            _loc34_ = new XMLNode(1,"NUMBER");
            _loc34_.appendChild(new XMLNode(3,this.workFaxNumber));
            _loc33_.appendChild(_loc34_);
            _loc5_.appendChild(_loc33_);
         }
         if(Boolean(this.workPagerNumber))
         {
            _loc35_ = new XMLNode(1,"TEL");
            _loc35_.appendChild(new XMLNode(1,"WORK"));
            _loc35_.appendChild(new XMLNode(1,"PAGER"));
            _loc36_ = new XMLNode(1,"NUMBER");
            _loc36_.appendChild(new XMLNode(3,this.workPagerNumber));
            _loc35_.appendChild(_loc36_);
            _loc5_.appendChild(_loc35_);
         }
         if(Boolean(this.workVoiceNumber))
         {
            _loc37_ = new XMLNode(1,"TEL");
            _loc37_.appendChild(new XMLNode(1,"WORK"));
            _loc37_.appendChild(new XMLNode(1,"VOICE"));
            _loc38_ = new XMLNode(1,"NUMBER");
            _loc38_.appendChild(new XMLNode(3,this.workVoiceNumber));
            _loc37_.appendChild(_loc38_);
            _loc5_.appendChild(_loc37_);
         }
         if(Boolean(this.homeCellNumber))
         {
            _loc39_ = new XMLNode(1,"TEL");
            _loc39_.appendChild(new XMLNode(1,"HOME"));
            _loc39_.appendChild(new XMLNode(1,"CELL"));
            _loc40_ = new XMLNode(1,"NUMBER");
            _loc40_.appendChild(new XMLNode(3,this.homeCellNumber));
            _loc39_.appendChild(_loc40_);
            _loc5_.appendChild(_loc39_);
         }
         if(Boolean(this.homeFaxNumber))
         {
            _loc41_ = new XMLNode(1,"TEL");
            _loc41_.appendChild(new XMLNode(1,"HOME"));
            _loc41_.appendChild(new XMLNode(1,"FAX"));
            _loc42_ = new XMLNode(1,"NUMBER");
            _loc42_.appendChild(new XMLNode(3,this.homeFaxNumber));
            _loc41_.appendChild(_loc42_);
            _loc5_.appendChild(_loc41_);
         }
         if(Boolean(this.homePagerNumber))
         {
            _loc43_ = new XMLNode(1,"TEL");
            _loc43_.appendChild(new XMLNode(1,"HOME"));
            _loc43_.appendChild(new XMLNode(1,"PAGER"));
            _loc44_ = new XMLNode(1,"NUMBER");
            _loc44_.appendChild(new XMLNode(3,this.homePagerNumber));
            _loc43_.appendChild(_loc44_);
            _loc5_.appendChild(_loc43_);
         }
         if(Boolean(this.homeVoiceNumber))
         {
            _loc45_ = new XMLNode(1,"TEL");
            _loc45_.appendChild(new XMLNode(1,"HOME"));
            _loc45_.appendChild(new XMLNode(1,"VOICE"));
            _loc46_ = new XMLNode(1,"NUMBER");
            _loc46_.appendChild(new XMLNode(3,this.homeVoiceNumber));
            _loc45_.appendChild(_loc46_);
            _loc5_.appendChild(_loc45_);
         }
         _loc3_.addExtension(_loc4_);
         param1.send(_loc3_);
      }
      
      public function _vCardSent(param1:IQ) : void
      {
         if(param1.type == IQ.ERROR_TYPE)
         {
            dispatchEvent(new VCardEvent(VCardEvent.ERROR,cache[param1.to.unescaped.toString()],true,true));
         }
         else
         {
            delete cache[param1.to.unescaped.toString()];
         }
      }
      
      public function handleVCard(param1:IQ) : void
      {
         var child:XMLNode = null;
         var xml:XML = null;
         var fullnameNode:XMLNode = null;
         var nicknameNode:XMLNode = null;
         var orgXML:XML = null;
         var titleNode:XMLNode = null;
         var urlNode:XMLNode = null;
         var adrXML:XML = null;
         var telXML:XML = null;
         var sChild:XMLNode = null;
         var value:String = null;
         var decoder:Base64Decoder = null;
         var emailChild:XMLNode = null;
         var iq:IQ = param1;
         var node:XMLNode = iq.getNode();
         var vCardNode:XMLNode = node.childNodes[0];
         if(!vCardNode)
         {
            return;
         }
         for each(child in vCardNode.childNodes)
         {
            switch(child.nodeName)
            {
               case "PHOTO":
                  for each(sChild in child.childNodes)
                  {
                     if(sChild.nodeName == "BINVAL")
                     {
                        try
                        {
                           if(sChild.childNodes.length == 0)
                           {
                              continue;
                           }
                           value = sChild.childNodes[0].nodeValue;
                           if(value.length > 0)
                           {
                              this._loader = new Loader();
                              decoder = new Base64Decoder();
                              decoder.decode(value);
                              this._imageBytes = decoder.flush();
                              dispatchEvent(new VCardEvent(VCardEvent.AVATAR_LOADED,this,true,false));
                           }
                        }
                        catch(e:Error)
                        {
                           continue;
                        }
                     }
                  }
                  break;
               case "N":
                  xml = new XML(child.toString());
                  this.firstName = xml.GIVEN;
                  this.middleName = xml.MIDDLE;
                  this.lastName = xml.FAMILY;
                  break;
               case "FN":
                  fullnameNode = child.childNodes[0];
                  if(Boolean(fullnameNode))
                  {
                     this.fullName = fullnameNode.nodeValue;
                  }
                  break;
               case "NICKNAME":
                  nicknameNode = child.childNodes[0];
                  if(Boolean(nicknameNode))
                  {
                     this.nickname = nicknameNode.nodeValue;
                  }
                  break;
               case "EMAIL":
                  for each(emailChild in child.childNodes)
                  {
                     if(emailChild.nodeName == "USERID")
                     {
                        if(emailChild.firstChild != null)
                        {
                           this.email = emailChild.firstChild.nodeValue;
                        }
                     }
                  }
                  break;
               case "ORG":
                  orgXML = new XML(child.toString());
                  this.company = orgXML.ORGNAME;
                  this.department = orgXML.ORGUNIT;
                  break;
               case "TITLE":
                  titleNode = child.childNodes[0];
                  if(Boolean(titleNode))
                  {
                     this.title = titleNode.nodeValue;
                  }
                  break;
               case "URL":
                  urlNode = child.childNodes[0];
                  if(Boolean(urlNode))
                  {
                     this.url = urlNode.nodeValue;
                  }
                  break;
               case "ADR":
                  adrXML = new XML(child.toString());
                  if(adrXML.WORK == "")
                  {
                     this.workPostalCode = adrXML.PCODE;
                     this.workStateProvince = adrXML.REGION;
                     this.workAddress = adrXML.STREET;
                     this.workCountry = adrXML.CTRY;
                     this.workCity = adrXML.LOCALITY;
                  }
                  else if(adrXML.HOME == "")
                  {
                     this.homePostalCode = adrXML.PCODE;
                     this.homeStateProvince = adrXML.REGION;
                     this.homeAddress = adrXML.STREET;
                     this.homeCountry = adrXML.CTRY;
                     this.homeCity = adrXML.LOCALITY;
                  }
                  break;
               case "TEL":
                  telXML = new XML(child.toString());
                  if(telXML.WORK == "")
                  {
                     if(telXML.VOICE == "")
                     {
                        this.workVoiceNumber = telXML.NUMBER;
                     }
                     else if(telXML.FAX == "")
                     {
                        this.workFaxNumber = telXML.NUMBER;
                     }
                     else if(telXML.PAGER == "")
                     {
                        this.workPagerNumber = telXML.NUMBER;
                     }
                     else if(telXML.CELL == "")
                     {
                        this.workCellNumber = telXML.NUMBER;
                     }
                  }
                  else if(telXML.HOME == "")
                  {
                     if(telXML.VOICE == "")
                     {
                        this.homeVoiceNumber = telXML.NUMBER;
                     }
                     else if(telXML.FAX == "")
                     {
                        this.homeFaxNumber = telXML.NUMBER;
                     }
                     else if(telXML.PAGER == "")
                     {
                        this.homePagerNumber = telXML.NUMBER;
                     }
                     else if(telXML.CELL == "")
                     {
                        this.homeCellNumber = telXML.NUMBER;
                     }
                  }
            }
         }
         this.loaded = true;
         dispatchEvent(new VCardEvent(VCardEvent.LOADED,this,true,false));
      }
      
      public function get avatar() : ByteArray
      {
         return this._imageBytes;
      }
      
      [Bindable(event="propertyChange")]
      public function get jid() : UnescapedJID
      {
         return this._105221jid;
      }
      
      public function set jid(param1:UnescapedJID) : void
      {
         var _loc2_:Object = this._105221jid;
         if(_loc2_ !== param1)
         {
            this._105221jid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"jid",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get firstName() : String
      {
         return this._132835675firstName;
      }
      
      public function set firstName(param1:String) : void
      {
         var _loc2_:Object = this._132835675firstName;
         if(_loc2_ !== param1)
         {
            this._132835675firstName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get middleName() : String
      {
         return this._818219584middleName;
      }
      
      public function set middleName(param1:String) : void
      {
         var _loc2_:Object = this._818219584middleName;
         if(_loc2_ !== param1)
         {
            this._818219584middleName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"middleName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lastName() : String
      {
         return this._1459599807lastName;
      }
      
      public function set lastName(param1:String) : void
      {
         var _loc2_:Object = this._1459599807lastName;
         if(_loc2_ !== param1)
         {
            this._1459599807lastName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nickname() : String
      {
         return this._70690926nickname;
      }
      
      public function set nickname(param1:String) : void
      {
         var _loc2_:Object = this._70690926nickname;
         if(_loc2_ !== param1)
         {
            this._70690926nickname = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nickname",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get email() : String
      {
         return this._96619420email;
      }
      
      public function set email(param1:String) : void
      {
         var _loc2_:Object = this._96619420email;
         if(_loc2_ !== param1)
         {
            this._96619420email = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"email",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fullName() : String
      {
         return this._1330852282fullName;
      }
      
      public function set fullName(param1:String) : void
      {
         var _loc2_:Object = this._1330852282fullName;
         if(_loc2_ !== param1)
         {
            this._1330852282fullName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fullName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get company() : String
      {
         return this._950484093company;
      }
      
      public function set company(param1:String) : void
      {
         var _loc2_:Object = this._950484093company;
         if(_loc2_ !== param1)
         {
            this._950484093company = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"company",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get department() : String
      {
         return this._848184146department;
      }
      
      public function set department(param1:String) : void
      {
         var _loc2_:Object = this._848184146department;
         if(_loc2_ !== param1)
         {
            this._848184146department = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"department",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get url() : String
      {
         return this._116079url;
      }
      
      public function set url(param1:String) : void
      {
         var _loc2_:Object = this._116079url;
         if(_loc2_ !== param1)
         {
            this._116079url = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"url",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workPostalCode() : String
      {
         return this._5014345workPostalCode;
      }
      
      public function set workPostalCode(param1:String) : void
      {
         var _loc2_:Object = this._5014345workPostalCode;
         if(_loc2_ !== param1)
         {
            this._5014345workPostalCode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workPostalCode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workStateProvince() : String
      {
         return this._310026416workStateProvince;
      }
      
      public function set workStateProvince(param1:String) : void
      {
         var _loc2_:Object = this._310026416workStateProvince;
         if(_loc2_ !== param1)
         {
            this._310026416workStateProvince = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workStateProvince",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workAddress() : String
      {
         return this._1299282013workAddress;
      }
      
      public function set workAddress(param1:String) : void
      {
         var _loc2_:Object = this._1299282013workAddress;
         if(_loc2_ !== param1)
         {
            this._1299282013workAddress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workAddress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workCountry() : String
      {
         return this._806241093workCountry;
      }
      
      public function set workCountry(param1:String) : void
      {
         var _loc2_:Object = this._806241093workCountry;
         if(_loc2_ !== param1)
         {
            this._806241093workCountry = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workCountry",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workCity() : String
      {
         return this._34333724workCity;
      }
      
      public function set workCity(param1:String) : void
      {
         var _loc2_:Object = this._34333724workCity;
         if(_loc2_ !== param1)
         {
            this._34333724workCity = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workCity",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homePostalCode() : String
      {
         return this._544819095homePostalCode;
      }
      
      public function set homePostalCode(param1:String) : void
      {
         var _loc2_:Object = this._544819095homePostalCode;
         if(_loc2_ !== param1)
         {
            this._544819095homePostalCode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homePostalCode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeStateProvince() : String
      {
         return this._655724610homeStateProvince;
      }
      
      public function set homeStateProvince(param1:String) : void
      {
         var _loc2_:Object = this._655724610homeStateProvince;
         if(_loc2_ !== param1)
         {
            this._655724610homeStateProvince = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeStateProvince",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeAddress() : String
      {
         return this._1534405099homeAddress;
      }
      
      public function set homeAddress(param1:String) : void
      {
         var _loc2_:Object = this._1534405099homeAddress;
         if(_loc2_ !== param1)
         {
            this._1534405099homeAddress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeAddress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeCountry() : String
      {
         return this._571118007homeCountry;
      }
      
      public function set homeCountry(param1:String) : void
      {
         var _loc2_:Object = this._571118007homeCountry;
         if(_loc2_ !== param1)
         {
            this._571118007homeCountry = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeCountry",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeCity() : String
      {
         return this._486704406homeCity;
      }
      
      public function set homeCity(param1:String) : void
      {
         var _loc2_:Object = this._486704406homeCity;
         if(_loc2_ !== param1)
         {
            this._486704406homeCity = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeCity",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workVoiceNumber() : String
      {
         return this._2032596810workVoiceNumber;
      }
      
      public function set workVoiceNumber(param1:String) : void
      {
         var _loc2_:Object = this._2032596810workVoiceNumber;
         if(_loc2_ !== param1)
         {
            this._2032596810workVoiceNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workVoiceNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workFaxNumber() : String
      {
         return this._601193291workFaxNumber;
      }
      
      public function set workFaxNumber(param1:String) : void
      {
         var _loc2_:Object = this._601193291workFaxNumber;
         if(_loc2_ !== param1)
         {
            this._601193291workFaxNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workFaxNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workPagerNumber() : String
      {
         return this._156166885workPagerNumber;
      }
      
      public function set workPagerNumber(param1:String) : void
      {
         var _loc2_:Object = this._156166885workPagerNumber;
         if(_loc2_ !== param1)
         {
            this._156166885workPagerNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workPagerNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get workCellNumber() : String
      {
         return this._800129340workCellNumber;
      }
      
      public function set workCellNumber(param1:String) : void
      {
         var _loc2_:Object = this._800129340workCellNumber;
         if(_loc2_ !== param1)
         {
            this._800129340workCellNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workCellNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeVoiceNumber() : String
      {
         return this._1586674876homeVoiceNumber;
      }
      
      public function set homeVoiceNumber(param1:String) : void
      {
         var _loc2_:Object = this._1586674876homeVoiceNumber;
         if(_loc2_ !== param1)
         {
            this._1586674876homeVoiceNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeVoiceNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeFaxNumber() : String
      {
         return this._1078787751homeFaxNumber;
      }
      
      public function set homeFaxNumber(param1:String) : void
      {
         var _loc2_:Object = this._1078787751homeFaxNumber;
         if(_loc2_ !== param1)
         {
            this._1078787751homeFaxNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeFaxNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homePagerNumber() : String
      {
         return this._602088819homePagerNumber;
      }
      
      public function set homePagerNumber(param1:String) : void
      {
         var _loc2_:Object = this._602088819homePagerNumber;
         if(_loc2_ !== param1)
         {
            this._602088819homePagerNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homePagerNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeCellNumber() : String
      {
         return this._1339934090homeCellNumber;
      }
      
      public function set homeCellNumber(param1:String) : void
      {
         var _loc2_:Object = this._1339934090homeCellNumber;
         if(_loc2_ !== param1)
         {
            this._1339934090homeCellNumber = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeCellNumber",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get loaded() : Boolean
      {
         return this._1097519099loaded;
      }
      
      public function set loaded(param1:Boolean) : void
      {
         var _loc2_:Object = this._1097519099loaded;
         if(_loc2_ !== param1)
         {
            this._1097519099loaded = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loaded",_loc2_,param1));
            }
         }
      }
   }
}

