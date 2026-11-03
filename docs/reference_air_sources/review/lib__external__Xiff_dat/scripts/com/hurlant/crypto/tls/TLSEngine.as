package com.hurlant.crypto.tls
{
   import com.hurlant.crypto.cert.X509Certificate;
   import com.hurlant.crypto.cert.X509CertificateCollection;
   import com.hurlant.crypto.prng.Random;
   import com.hurlant.util.ArrayUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   [Event(name="data",type="com.hurlant.crypto.tls.TLSEvent")]
   [Event(name="ready",type="com.hurlant.crypto.tls.TLSEvent")]
   [Event(name="socketData",type="flash.events.ProgressEvent")]
   [Event(name="close",type="flash.events.Event")]
   public class TLSEngine extends EventDispatcher
   {
      
      public static const SERVER:uint = 0;
      
      public static const CLIENT:uint = 1;
      
      public static const TLS_VERSION:uint = 769;
      
      private static const PROTOCOL_HANDSHAKE:uint = 22;
      
      private static const PROTOCOL_ALERT:uint = 21;
      
      private static const PROTOCOL_CHANGE_CIPHER_SPEC:uint = 20;
      
      private static const PROTOCOL_APPLICATION_DATA:uint = 23;
      
      private static const STATE_NEW:uint = 0;
      
      private static const STATE_NEGOTIATING:uint = 1;
      
      private static const STATE_READY:uint = 2;
      
      private static const STATE_CLOSED:uint = 3;
      
      private static const HANDSHAKE_HELLO_REQUEST:uint = 0;
      
      private static const HANDSHAKE_CLIENT_HELLO:uint = 1;
      
      private static const HANDSHAKE_SERVER_HELLO:uint = 2;
      
      private static const HANDSHAKE_CERTIFICATE:uint = 11;
      
      private static const HANDSHAKE_SERVER_KEY_EXCHANGE:uint = 12;
      
      private static const HANDSHAKE_CERTIFICATE_REQUEST:uint = 13;
      
      private static const HANDSHAKE_HELLO_DONE:uint = 14;
      
      private static const HANDSHAKE_CERTIFICATE_VERIFY:uint = 15;
      
      private static const HANDSHAKE_CLIENT_KEY_EXCHANGE:uint = 16;
      
      private static const HANDSHAKE_FINISHED:uint = 20;
      
      private var _entity:uint;
      
      private var _config:TLSConfig;
      
      private var _state:uint;
      
      private var _securityParameters:TLSSecurityParameters;
      
      private var _currentReadState:TLSConnectionState;
      
      private var _currentWriteState:TLSConnectionState;
      
      private var _pendingReadState:TLSConnectionState;
      
      private var _pendingWriteState:TLSConnectionState;
      
      private var _handshakePayloads:ByteArray;
      
      private var _iStream:IDataInput;
      
      private var _oStream:IDataOutput;
      
      private var _store:X509CertificateCollection;
      
      private var _otherCertificate:X509Certificate;
      
      private var _otherIdentity:String;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _packetQueue:Array = [];
      
      private var _writeScheduler:uint;
      
      public function TLSEngine(param1:TLSConfig, param2:IDataInput, param3:IDataOutput, param4:String = null)
      {
         super();
         this._entity = param1.entity;
         this._config = param1;
         this._iStream = param2;
         this._oStream = param3;
         this._otherIdentity = param4;
         this._state = STATE_NEW;
         this._securityParameters = new TLSSecurityParameters(this._entity);
         var _loc5_:Object = this._securityParameters.getConnectionStates();
         this._currentReadState = _loc5_.read;
         this._currentWriteState = _loc5_.write;
         this._handshakePayloads = new ByteArray();
         this._store = new X509CertificateCollection();
      }
      
      public function start() : void
      {
         if(this._entity == CLIENT)
         {
            try
            {
               this.startHandshake();
            }
            catch(e:TLSError)
            {
               handleTLSError(e);
            }
         }
      }
      
      public function dataAvailable(param1:* = null) : void
      {
         var e:* = param1;
         if(this._state == STATE_CLOSED)
         {
            return;
         }
         try
         {
            this.parseRecord(this._iStream);
         }
         catch(e:TLSError)
         {
            handleTLSError(e);
         }
      }
      
      public function close(param1:TLSError = null) : void
      {
         if(this._state == STATE_CLOSED)
         {
            return;
         }
         var _loc2_:ByteArray = new ByteArray();
         if(param1 == null && this._state != STATE_READY)
         {
            _loc2_[0] = 1;
            _loc2_[1] = TLSError.user_canceled;
            this.sendRecord(PROTOCOL_ALERT,_loc2_);
         }
         _loc2_[0] = 2;
         if(param1 == null)
         {
            _loc2_[1] = TLSError.close_notify;
         }
         else
         {
            _loc2_[1] = param1.errorID;
            this.logger.error("TSLEngine.close: TLSEngine shutdown triggered by " + param1);
         }
         this.sendRecord(PROTOCOL_ALERT,_loc2_);
         this._state = STATE_CLOSED;
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function parseRecord(param1:IDataInput) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         while(this._state != STATE_CLOSED && param1.bytesAvailable > 4)
         {
            if(this._packetQueue.length > 0)
            {
               _loc7_ = this._packetQueue.shift();
               _loc2_ = _loc7_.data;
               if(param1.bytesAvailable + _loc2_.length >= _loc7_.length)
               {
                  param1.readBytes(_loc2_,_loc2_.length,_loc7_.length - _loc2_.length);
                  this.parseOneRecord(_loc7_.type,_loc7_.length,_loc2_);
               }
               else
               {
                  param1.readBytes(_loc2_,_loc2_.length,param1.bytesAvailable);
                  this._packetQueue.push(_loc7_);
               }
            }
            else
            {
               _loc3_ = uint(param1.readByte());
               _loc4_ = uint(param1.readShort());
               _loc5_ = uint(param1.readShort());
               if(_loc5_ > 16384 + 2048)
               {
                  throw new TLSError("Excessive TLS Record length: " + _loc5_,TLSError.record_overflow);
               }
               if(_loc4_ != TLS_VERSION)
               {
                  throw new TLSError("Unsupported TLS version: " + _loc4_.toString(16),TLSError.protocol_version);
               }
               if(param1.bytesAvailable < _loc5_)
               {
               }
               _loc2_ = new ByteArray();
               _loc6_ = Math.min(param1.bytesAvailable,_loc5_);
               param1.readBytes(_loc2_,0,_loc6_);
               if(_loc6_ == _loc5_)
               {
                  this.parseOneRecord(_loc3_,_loc5_,_loc2_);
               }
               else
               {
                  this._packetQueue.push({
                     "type":_loc3_,
                     "length":_loc5_,
                     "data":_loc2_
                  });
               }
            }
         }
      }
      
      private function parseOneRecord(param1:uint, param2:uint, param3:ByteArray) : void
      {
         param3 = this._currentReadState.decrypt(param1,param2,param3);
         if(param3.length > 16384)
         {
            throw new TLSError("Excessive Decrypted TLS Record length: " + param3.length,TLSError.record_overflow);
         }
         switch(param1)
         {
            case PROTOCOL_APPLICATION_DATA:
               if(this._state == STATE_READY)
               {
                  this.parseApplicationData(param3);
                  break;
               }
               throw new TLSError("Too soon for data!",TLSError.unexpected_message);
               break;
            case PROTOCOL_HANDSHAKE:
               while(param3 != null)
               {
                  param3 = this.parseHandshake(param3);
               }
               break;
            case PROTOCOL_ALERT:
               this.parseAlert(param3);
               break;
            case PROTOCOL_CHANGE_CIPHER_SPEC:
               this.parseChangeCipherSpec(param3);
               break;
            default:
               throw new TLSError("Unsupported TLS Record Content Type: " + param1.toString(16),TLSError.unexpected_message);
         }
      }
      
      private function startHandshake() : void
      {
         this._state = STATE_NEGOTIATING;
         this.sendClientHello();
      }
      
      private function parseHandshake(param1:ByteArray) : ByteArray
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:ByteArray = null;
         var _loc10_:uint = 0;
         var _loc11_:ByteArray = null;
         var _loc12_:ByteArray = null;
         if(param1.length < 4)
         {
            this.logger.error("TLSEngine.parseHandshake: Handshake packet is way too short.  bailing.");
            return null;
         }
         param1.position = 0;
         _loc2_ = param1;
         _loc3_ = _loc2_.readUnsignedByte();
         _loc4_ = _loc2_.readUnsignedByte();
         _loc5_ = uint(_loc4_ << 16 | _loc2_.readUnsignedShort());
         if(_loc5_ + 4 > param1.length)
         {
            this.logger.error("TLSEngine.parseHandshake: Handshake packet is incomplete. bailing.");
            return null;
         }
         if(param1[0] != HANDSHAKE_FINISHED)
         {
            this._handshakePayloads.writeBytes(param1,0,_loc5_ + 4);
         }
         switch(_loc3_)
         {
            case HANDSHAKE_HELLO_REQUEST:
               if(!this.enforceClient())
               {
                  break;
               }
               if(this._state != STATE_READY)
               {
                  this.logger.warn("TSLEngine.parseHandshake: Received an HELLO_REQUEST before being in state READY. ignoring.");
                  break;
               }
               this._handshakePayloads = new ByteArray();
               this.startHandshake();
               break;
            case HANDSHAKE_CLIENT_HELLO:
               if(!this.enforceServer())
               {
                  break;
               }
               _loc6_ = this.parseHandshakeHello(_loc3_,_loc5_,_loc2_);
               this.sendServerHello(_loc6_);
               this.sendCertificate();
               this.sendServerHelloDone();
               break;
            case HANDSHAKE_SERVER_HELLO:
               if(!this.enforceClient())
               {
                  break;
               }
               _loc6_ = this.parseHandshakeHello(_loc3_,_loc5_,_loc2_);
               this._securityParameters.setCipher(_loc6_.suites[0]);
               this._securityParameters.setCompression(_loc6_.compressions[0]);
               this._securityParameters.setServerRandom(_loc6_.random);
               break;
            case HANDSHAKE_CERTIFICATE:
               _loc4_ = uint(_loc2_.readByte());
               _loc7_ = uint(_loc4_ << 16 | _loc2_.readShort());
               _loc8_ = [];
               while(_loc7_ > 0)
               {
                  _loc4_ = uint(_loc2_.readByte());
                  _loc10_ = uint(_loc4_ << 16 | _loc2_.readShort());
                  _loc11_ = new ByteArray();
                  _loc2_.readBytes(_loc11_,0,_loc10_);
                  _loc8_.push(_loc11_);
                  _loc7_ -= 3 + _loc10_;
               }
               this.loadCertificates(_loc8_);
               break;
            case HANDSHAKE_SERVER_KEY_EXCHANGE:
               if(!this.enforceClient())
               {
                  break;
               }
               throw new TLSError("Server Key Exchange Not Implemented",TLSError.internal_error);
               break;
            case HANDSHAKE_CERTIFICATE_REQUEST:
               if(!this.enforceClient())
               {
                  break;
               }
               throw new TLSError("Certificate Request Not Implemented",TLSError.internal_error);
               break;
            case HANDSHAKE_HELLO_DONE:
               if(!this.enforceClient())
               {
                  break;
               }
               this.sendClientAck();
               break;
            case HANDSHAKE_CLIENT_KEY_EXCHANGE:
               if(!this.enforceServer())
               {
                  break;
               }
               this.parseHandshakeClientKeyExchange(_loc3_,_loc5_,_loc2_);
               break;
            case HANDSHAKE_CERTIFICATE_VERIFY:
               if(!this.enforceServer())
               {
                  break;
               }
               throw new TLSError("Certificate Verify not implemented",TLSError.internal_error);
               break;
            case HANDSHAKE_FINISHED:
               _loc9_ = new ByteArray();
               _loc2_.readBytes(_loc9_,0,12);
               this.verifyHandshake(_loc9_);
         }
         if(_loc5_ + 4 < param1.length)
         {
            _loc12_ = new ByteArray();
            _loc12_.writeBytes(param1,_loc5_ + 4,param1.length - (_loc5_ + 4));
            return _loc12_;
         }
         return null;
      }
      
      private function verifyHandshake(param1:ByteArray) : void
      {
         var _loc2_:ByteArray = this._securityParameters.computeVerifyData(1 - this._entity,this._handshakePayloads);
         if(ArrayUtil.equals(param1,_loc2_))
         {
            this._state = STATE_READY;
            dispatchEvent(new TLSEvent(TLSEvent.READY));
            return;
         }
         throw new TLSError("Invalid Finished mac.",TLSError.bad_record_mac);
      }
      
      private function enforceClient() : Boolean
      {
         if(this._entity == SERVER)
         {
            this.logger.info("TLSEngine.enforceClient: Invalid state for a TLS server.");
            return false;
         }
         return true;
      }
      
      private function enforceServer() : Boolean
      {
         if(this._entity == CLIENT)
         {
            this.logger.info("TLSEngine.enforceServer: Invalid state for a TLS client.");
            return false;
         }
         return true;
      }
      
      private function parseHandshakeClientKeyExchange(param1:uint, param2:uint, param3:ByteArray) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:ByteArray = null;
         var _loc7_:Object = null;
         if(this._securityParameters.useRSA)
         {
            _loc4_ = uint(param3.readShort());
            _loc5_ = new ByteArray();
            param3.readBytes(_loc5_,0,_loc4_);
            _loc6_ = new ByteArray();
            this._config.privateKey.decrypt(_loc5_,_loc6_,_loc4_);
            this._securityParameters.setPreMasterSecret(_loc6_);
            _loc7_ = this._securityParameters.getConnectionStates();
            this._pendingReadState = _loc7_.read;
            this._pendingWriteState = _loc7_.write;
            return;
         }
         throw new TLSError("parseHandshakeClientKeyExchange not implemented for DH modes.",TLSError.internal_error);
      }
      
      private function parseHandshakeHello(param1:uint, param2:uint, param3:IDataInput) : Object
      {
         var _loc4_:Object = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:Array = null;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:ByteArray = null;
         var _loc5_:uint = uint(param3.readShort());
         if(_loc5_ != TLS_VERSION)
         {
            throw new TLSError("Unsupported TLS version: " + _loc5_.toString(16),TLSError.protocol_version);
         }
         var _loc6_:ByteArray = new ByteArray();
         param3.readBytes(_loc6_,0,32);
         var _loc7_:uint = uint(param3.readByte());
         var _loc8_:ByteArray = new ByteArray();
         if(_loc7_ > 0)
         {
            param3.readBytes(_loc8_,0,_loc7_);
         }
         var _loc9_:Array = [];
         if(param1 == HANDSHAKE_CLIENT_HELLO)
         {
            _loc11_ = uint(param3.readShort());
            _loc12_ = 0;
            while(_loc12_ < _loc11_ / 2)
            {
               _loc9_.push(param3.readShort());
               _loc12_++;
            }
         }
         else
         {
            _loc9_.push(param3.readShort());
         }
         var _loc10_:Array = [];
         if(param1 == HANDSHAKE_CLIENT_HELLO)
         {
            _loc13_ = uint(param3.readByte());
            _loc12_ = 0;
            while(_loc12_ < _loc13_)
            {
               _loc10_.push(param3.readByte());
               _loc12_++;
            }
         }
         else
         {
            _loc10_.push(param3.readByte());
         }
         _loc4_ = {
            "random":_loc6_,
            "session":_loc8_,
            "suites":_loc9_,
            "compressions":_loc10_
         };
         if(param1 == HANDSHAKE_CLIENT_HELLO)
         {
            _loc14_ = 2 + 32 + 1 + _loc7_ + 2 + _loc11_ + 1 + _loc13_;
            _loc15_ = [];
            if(_loc14_ < param2)
            {
               _loc16_ = uint(param3.readShort());
               while(_loc16_ > 0)
               {
                  _loc17_ = uint(param3.readShort());
                  _loc18_ = uint(param3.readShort());
                  _loc19_ = new ByteArray();
                  param3.readBytes(_loc19_,0,_loc18_);
                  _loc16_ -= 4 + _loc18_;
                  _loc15_.push({
                     "type":_loc17_,
                     "length":_loc18_,
                     "data":_loc19_
                  });
               }
            }
            _loc4_.ext = _loc15_;
         }
         return _loc4_;
      }
      
      private function sendClientHello() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeShort(TLS_VERSION);
         var _loc2_:Random = new Random();
         var _loc3_:ByteArray = new ByteArray();
         _loc2_.nextBytes(_loc3_,32);
         this._securityParameters.setClientRandom(_loc3_);
         _loc1_.writeBytes(_loc3_,0,32);
         _loc1_.writeByte(32);
         _loc2_.nextBytes(_loc1_,32);
         var _loc4_:Array = this._config.cipherSuites;
         _loc1_.writeShort(2 * _loc4_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc1_.writeShort(_loc4_[_loc5_]);
            _loc5_++;
         }
         _loc4_ = this._config.compressions;
         _loc1_.writeByte(_loc4_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc1_.writeByte(_loc4_[_loc5_]);
            _loc5_++;
         }
         _loc1_.position = 0;
         this.sendHandshake(HANDSHAKE_CLIENT_HELLO,_loc1_.length,_loc1_);
      }
      
      private function findMatch(param1:Array, param2:Array) : int
      {
         var _loc4_:uint = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = uint(param1[_loc3_]);
            if(param2.indexOf(_loc4_) > -1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function sendServerHello(param1:Object) : void
      {
         var _loc2_:int = this.findMatch(this._config.cipherSuites,param1.suites);
         if(_loc2_ == -1)
         {
            throw new TLSError("No compatible cipher found.",TLSError.handshake_failure);
         }
         this._securityParameters.setCipher(_loc2_);
         var _loc3_:int = this.findMatch(this._config.compressions,param1.compressions);
         if(_loc3_ == 1)
         {
            throw new TLSError("No compatible compression method found.",TLSError.handshake_failure);
         }
         this._securityParameters.setCompression(_loc3_);
         this._securityParameters.setClientRandom(param1.random);
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeShort(TLS_VERSION);
         var _loc5_:Random = new Random();
         var _loc6_:ByteArray = new ByteArray();
         _loc5_.nextBytes(_loc6_,32);
         this._securityParameters.setServerRandom(_loc6_);
         _loc4_.writeBytes(_loc6_,0,32);
         _loc4_.writeByte(32);
         _loc5_.nextBytes(_loc4_,32);
         _loc4_.writeShort(param1.suites[0]);
         _loc4_.writeByte(param1.compressions[0]);
         _loc4_.position = 0;
         this.sendHandshake(HANDSHAKE_SERVER_HELLO,_loc4_.length,_loc4_);
      }
      
      private function sendCertificate() : void
      {
         var _loc1_:ByteArray = this._config.certificate;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:uint = _loc1_.length;
         var _loc3_:uint = _loc2_ + 3;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeByte(_loc3_ >> 16);
         _loc4_.writeShort(_loc3_ & 0xFFFF);
         _loc4_.writeByte(_loc2_ >> 16);
         _loc4_.writeShort(_loc2_ & 0xFFFF);
         _loc4_.writeBytes(_loc1_);
         _loc4_.position = 0;
         this.sendHandshake(HANDSHAKE_CERTIFICATE,_loc4_.length,_loc4_);
      }
      
      private function sendDummyClientCertificate() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeShort(TLS_VERSION);
         var _loc2_:Random = new Random();
         _loc2_.nextBytes(_loc1_,46);
         _loc1_.position = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(_loc1_,0,_loc1_.length);
         this._securityParameters.setPreMasterSecret(_loc3_);
         var _loc4_:ByteArray = new ByteArray();
         this._otherCertificate.getPublicKey().encrypt(_loc1_,_loc4_,_loc1_.length);
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeShort(_loc4_.length);
         _loc5_.writeBytes(_loc4_,0,_loc4_.length);
         _loc5_.position = 0;
         this.sendHandshake(HANDSHAKE_CERTIFICATE_REQUEST,_loc5_.length,_loc5_);
      }
      
      private function sendServerHelloDone() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         this.sendHandshake(HANDSHAKE_HELLO_DONE,_loc1_.length,_loc1_);
      }
      
      private function sendClientKeyExchange() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:Random = null;
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         var _loc5_:ByteArray = null;
         var _loc6_:Object = null;
         if(this._securityParameters.useRSA)
         {
            _loc1_ = new ByteArray();
            _loc1_.writeShort(TLS_VERSION);
            _loc2_ = new Random();
            _loc2_.nextBytes(_loc1_,46);
            _loc1_.position = 0;
            _loc3_ = new ByteArray();
            _loc3_.writeBytes(_loc1_,0,_loc1_.length);
            this._securityParameters.setPreMasterSecret(_loc3_);
            _loc4_ = new ByteArray();
            this._otherCertificate.getPublicKey().encrypt(_loc1_,_loc4_,_loc1_.length);
            _loc5_ = new ByteArray();
            _loc5_.writeShort(_loc4_.length);
            _loc5_.writeBytes(_loc4_,0,_loc4_.length);
            _loc5_.position = 0;
            this.sendHandshake(HANDSHAKE_CLIENT_KEY_EXCHANGE,_loc5_.length,_loc5_);
            _loc6_ = this._securityParameters.getConnectionStates();
            this._pendingReadState = _loc6_.read;
            this._pendingWriteState = _loc6_.write;
            return;
         }
         throw new TLSError("Non-RSA Client Key Exchange not implemented.",TLSError.internal_error);
      }
      
      private function sendFinished() : void
      {
         var _loc1_:ByteArray = this._securityParameters.computeVerifyData(this._entity,this._handshakePayloads);
         _loc1_.position = 0;
         this.sendHandshake(HANDSHAKE_FINISHED,_loc1_.length,_loc1_);
      }
      
      private function sendHandshake(param1:uint, param2:uint, param3:IDataInput) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeByte(param1);
         _loc4_.writeByte(0);
         _loc4_.writeShort(param2);
         param3.readBytes(_loc4_,_loc4_.position,param2);
         this._handshakePayloads.writeBytes(_loc4_,0,_loc4_.length);
         this.sendRecord(PROTOCOL_HANDSHAKE,_loc4_);
      }
      
      private function sendChangeCipherSpec() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_[0] = 1;
         this.sendRecord(PROTOCOL_CHANGE_CIPHER_SPEC,_loc1_);
         this._currentWriteState = this._pendingWriteState;
         this._pendingWriteState = null;
      }
      
      public function sendApplicationData(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:uint = param3;
         if(_loc5_ == 0)
         {
            _loc5_ = param1.length;
         }
         while(_loc5_ > 16384)
         {
            _loc4_.position = 0;
            _loc4_.writeBytes(param1,param2,16384);
            _loc4_.position = 0;
            this.sendRecord(PROTOCOL_APPLICATION_DATA,_loc4_);
            param2 += 16384;
            _loc5_ -= 16384;
         }
         _loc4_.position = 0;
         _loc4_.writeBytes(param1,param2,_loc5_);
         _loc4_.length = _loc5_;
         _loc4_.position = 0;
         this.sendRecord(PROTOCOL_APPLICATION_DATA,_loc4_);
      }
      
      private function sendRecord(param1:uint, param2:ByteArray) : void
      {
         param2 = this._currentWriteState.encrypt(param1,param2);
         this._oStream.writeByte(param1);
         this._oStream.writeShort(TLS_VERSION);
         this._oStream.writeShort(param2.length);
         this._oStream.writeBytes(param2,0,param2.length);
         this.scheduleWrite();
      }
      
      private function scheduleWrite() : void
      {
         if(this._writeScheduler != 0)
         {
            return;
         }
         this._writeScheduler = setTimeout(this.commitWrite,0);
      }
      
      private function commitWrite() : void
      {
         clearTimeout(this._writeScheduler);
         this._writeScheduler = 0;
         if(this._state != STATE_CLOSED)
         {
            dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
         }
      }
      
      private function sendClientAck() : void
      {
         this.sendClientKeyExchange();
         this.sendChangeCipherSpec();
         this.sendFinished();
      }
      
      private function loadCertificates(param1:Array) : void
      {
         var _loc4_:X509Certificate = null;
         var _loc5_:String = null;
         var _loc2_:X509Certificate = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new X509Certificate(param1[_loc3_]);
            this._store.addCertificate(_loc4_);
            if(_loc2_ == null)
            {
               _loc2_ = _loc4_;
            }
            _loc3_++;
         }
         if(_loc2_.isSigned(this._store,this._config.CAStore))
         {
            if(this._otherIdentity == null)
            {
               this._otherCertificate = _loc2_;
            }
            else
            {
               _loc5_ = _loc2_.getCommonName();
               if(!(_loc5_ == this._otherIdentity || this.wildcardEq(_loc5_,this._otherIdentity)))
               {
                  throw new TLSError("Invalid common name: " + _loc2_.getCommonName() + ", expected " + this._otherIdentity,TLSError.bad_certificate);
               }
               this._otherCertificate = _loc2_;
            }
         }
         else
         {
            if(!this._config.acceptSelfSignedCert)
            {
               throw new TLSError("Cannot verify certificate (Self-signed certificate).",TLSError.bad_certificate);
            }
            this.logger.warn("TLSEngine.loadCertificates: TLS WARNING: Self-signed certificate used.");
            this._otherCertificate = _loc2_;
         }
         if(this._config.expectedCertificate != null)
         {
            this.logger.debug("TLSEngine.loadCertificates: Checking for expected certificate ");
            if(this._otherCertificate.getPublicKey().dump() != this._config.expectedCertificate.getPublicKey().dump())
            {
               this.logger.error("TLSEngine.loadCertificates: TLS ERROR: Cannot verify expected certificate.");
               throw new TLSError("Cannot verify expected certificate.",TLSError.bad_certificate);
            }
         }
      }
      
      private function wildcardEq(param1:String, param2:String) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1.charAt(0) == "*")
         {
            _loc3_ = param1.split(".");
            _loc4_ = param2.split(".");
            _loc5_ = _loc3_.length;
            _loc6_ = _loc4_.length;
            return _loc3_[_loc5_ - 2] == _loc4_[_loc6_ - 2] && _loc3_[_loc5_ - 1] == _loc4_[_loc6_ - 1];
         }
         return false;
      }
      
      private function parseAlert(param1:ByteArray) : void
      {
         this.logger.info("TLSEngine.parseAlert: GOT ALERT! type=" + param1[1]);
         this.close();
      }
      
      private function parseChangeCipherSpec(param1:ByteArray) : void
      {
         param1.readUnsignedByte();
         if(this._pendingReadState == null)
         {
            throw new TLSError("Not ready to Change Cipher Spec, damnit.",TLSError.unexpected_message);
         }
         this._currentReadState = this._pendingReadState;
         this._pendingReadState = null;
      }
      
      private function parseApplicationData(param1:ByteArray) : void
      {
         dispatchEvent(new TLSEvent(TLSEvent.DATA,param1));
      }
      
      private function handleTLSError(param1:TLSError) : void
      {
         this.logger.error("TLSEngine.handleTLSError: [" + param1.errorID + "] - " + param1.message + "\n" + param1.getStackTrace());
         this.close(param1);
      }
   }
}

