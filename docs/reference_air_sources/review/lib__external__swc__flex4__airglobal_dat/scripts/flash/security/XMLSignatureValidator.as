package flash.security
{
   import flash.errors.*;
   import flash.events.*;
   import flash.utils.*;
   
   [API("661")]
   [native(cls="XMLSignatureValidatorClass",instance="XMLSignatureValidatorObject",gc="exact",methods="auto")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class XMLSignatureValidator extends EventDispatcher
   {
      
      private static const XML_DSIG_NS:Namespace = new Namespace("http://www.w3.org/2000/09/xmldsig#");
      
      private static const XML_XADES_NAMESPACE:String = "http://uri.etsi.org/01903/v1.1.1#";
      
      private static const XMLDIGESTMETHOD_SHA256:String = "http://www.w3.org/2001/04/xmlenc#sha256";
      
      private static const XML_TRANSFORM_C14N:String = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315";
      
      private static const XML_TRANSFORM_ENVELOPED_SIGNATURE:String = "http://www.w3.org/2000/09/xmldsig#enveloped-signature";
      
      private static const MAX_NUM_TRANSFORMS:uint = 20;
      
      private static const kInvalidParamError:uint = 2004;
      
      private static const kNullPointerError:uint = 2007;
      
      private static const kInvalidCallError:uint = 2037;
      
      private static const VALID_IDENTITY:String = "validIdentity";
      
      private static const VALID_OR_UNKNOWN_IDENTITY:String = "validOrUnknownIdentity";
      
      private static const NEVER:String = "never";
      
      private var m_uriDereferencer:IURIDereferencer;
      
      private var m_isValidating:Boolean;
      
      private var m_referencesValidationSetting:String;
      
      private var m_cryptContext:CryptContext;
      
      private var m_referenceStatus:String;
      
      private var m_signedDataString:String;
      
      private var m_sigValueString:String;
      
      private var m_timestampUris:Array = ["SignatureValue","#PackageSignatureValue"];
      
      private var _ignoreCertTime:Boolean = false;
      
      private var stubProperties:Object;
      
      public function XMLSignatureValidator()
      {
         super();
         this.m_isValidating = false;
         this.m_referencesValidationSetting = VALID_IDENTITY;
         this.m_cryptContext = this.constructCryptContext();
         this.m_referenceStatus = SignatureStatus.UNKNOWN;
      }
      
      [Version("air2.0")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      public function get uriDereferencer() : IURIDereferencer
      {
         return this.m_uriDereferencer;
      }
      
      public function set uriDereferencer(uriDerefer:IURIDereferencer) : void
      {
         this.throwIfValidating();
         this.m_uriDereferencer = uriDerefer;
      }
      
      public function addCertificate(cert:ByteArray, trusted:Boolean) : *
      {
         this.throwIfValidating();
         this.m_cryptContext.addChainBuildingCertRaw(cert,trusted);
      }
      
      public function get useSystemTrustStore() : Boolean
      {
         return this.m_cryptContext.getUseSystemTrustStore();
      }
      
      public function set useSystemTrustStore(trusted:Boolean) : void
      {
         this.throwIfValidating();
         this.m_cryptContext.useSystemTrustStore(trusted);
      }
      
      public function get revocationCheckSetting() : String
      {
         return this.m_cryptContext.getRevCheckSetting();
      }
      
      public function set revocationCheckSetting(setting:String) : void
      {
         this.throwIfValidating();
         this.m_cryptContext.setRevCheckSetting(setting);
      }
      
      [API("663")]
      public function get referencesValidationSetting() : String
      {
         return this.m_referencesValidationSetting;
      }
      
      [API("663")]
      public function set referencesValidationSetting(setting:String) : void
      {
         this.throwIfValidating();
         if(!(setting == NEVER || setting == VALID_OR_UNKNOWN_IDENTITY || setting == VALID_IDENTITY))
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         this.m_referencesValidationSetting = setting;
         if(setting == VALID_OR_UNKNOWN_IDENTITY)
         {
            this.m_cryptContext.useCodeSigningValidationRules();
         }
      }
      
      private function cryptContextCodeToStatus(cryptContextCode:uint) : String
      {
         switch(cryptContextCode)
         {
            case CryptContext.STATUS_VALID:
               return SignatureStatus.VALID;
            case CryptContext.STATUS_INVALID:
               return SignatureStatus.INVALID;
            case CryptContext.STATUS_UNKNOWN:
            case CryptContext.STATUS_TROUBLE:
         }
         return SignatureStatus.UNKNOWN;
      }
      
      private function throwIfValidating() : *
      {
         if(this.m_isValidating)
         {
            Error.throwError(IllegalOperationError,kInvalidCallError);
         }
      }
      
      public function get referencesStatus() : String
      {
         this.throwIfValidating();
         return this.m_referenceStatus;
      }
      
      public function get digestStatus() : String
      {
         this.throwIfValidating();
         return this.cryptContextCodeToStatus(this.m_cryptContext.getDataTBVStatus());
      }
      
      public function get identityStatus() : String
      {
         this.throwIfValidating();
         return this.cryptContextCodeToStatus(this.m_cryptContext.getIDStatus());
      }
      
      public function get validityStatus() : String
      {
         this.throwIfValidating();
         if(this.referencesStatus == SignatureStatus.VALID)
         {
            return this.cryptContextCodeToStatus(this.m_cryptContext.getOverallStatus());
         }
         if(this.referencesStatus == SignatureStatus.INVALID)
         {
            return SignatureStatus.INVALID;
         }
         return this.m_cryptContext.getOverallStatus() == CryptContext.STATUS_INVALID ? SignatureStatus.INVALID : SignatureStatus.UNKNOWN;
      }
      
      public function get signerTrustSettings() : Array
      {
         this.throwIfValidating();
         return this.m_cryptContext.getSignerTrustSettings();
      }
      
      public function get signerExtendedKeyUsages() : Array
      {
         this.throwIfValidating();
         return this.m_cryptContext.getSignerExtendedKeyUsages();
      }
      
      private function applyTransforms(inData:IDataInput, transforms:XMLList, signature:XML) : IDataInput
      {
         var c14ner:XMLCanonicalizer = null;
         var oneTransform:XML = null;
         var resultString:String = null;
         var xmlResult:XML = null;
         var newResult:ByteArray = null;
         var containingDoc:XML = null;
         var transformer:XMLSignatureEnvelopedTransformer = null;
         var docMinusSig:XML = null;
         if(transforms != null && transforms.length() > MAX_NUM_TRANSFORMS)
         {
            throw new Error("too many transforms to process");
         }
         var result:IDataInput = inData;
         if(transforms != null && transforms.length() > 0)
         {
            c14ner = this.constructXMLCanonicalizer();
            for each(oneTransform in transforms)
            {
               if(oneTransform.@Algorithm == XML_TRANSFORM_C14N)
               {
                  resultString = result.readUTFBytes(result.bytesAvailable);
                  xmlResult = new XML(resultString);
                  newResult = new ByteArray();
                  newResult.writeUTFBytes(c14ner.CanonicalizeXML(xmlResult));
                  newResult.position = 0;
                  result = newResult;
               }
               else
               {
                  if(oneTransform.@Algorithm != XML_TRANSFORM_ENVELOPED_SIGNATURE)
                  {
                     throw new Error("unsupported XML transform: " + oneTransform.@Algorithm);
                  }
                  resultString = result.readUTFBytes(result.bytesAvailable);
                  containingDoc = new XML(resultString);
                  transformer = this.constructEnvelopedTransformer();
                  docMinusSig = transformer.transform(signature,containingDoc);
                  newResult = new ByteArray();
                  newResult.writeUTFBytes(c14ner.CanonicalizeXML(docMinusSig));
                  result = newResult;
               }
            }
         }
         return result;
      }
      
      private function verifyReferences(signature:XML) : Boolean
      {
         var oneRef:XML = null;
         var xmlDigest:String = null;
         var computedDigest:AVMPlusDigest = null;
         var digestValidationResult:uint = 0;
         var transforms:XMLList = null;
         var oneTransform:XML = null;
         var result:IDataInput = null;
         var resultString:* = undefined;
         var xmlResult:XML = null;
         var newResult:ByteArray = null;
         var containingDoc:XML = null;
         var transformer:XMLSignatureEnvelopedTransformer = null;
         var docMinusSig:XML = null;
         var signedData:XML = XML(signature.XML_DSIG_NS::SignedInfo);
         var references:XMLList = signedData.XML_DSIG_NS::Reference;
         this.m_referenceStatus = SignatureStatus.UNKNOWN;
         var allRefValid:Boolean = true;
         var c14ner:XMLCanonicalizer = this.constructXMLCanonicalizer();
         for each(oneRef in references)
         {
            xmlDigest = oneRef.XML_DSIG_NS::DigestValue.toString();
            computedDigest = this.constructAVMPlusDigest();
            digestValidationResult = 0;
            if(oneRef.XML_DSIG_NS::DigestMethod.@Algorithm != XMLDIGESTMETHOD_SHA256)
            {
               throw new Error("unsupported XML Digest algorithm: " + oneRef.XML_DSIG_NS::DigestMethod.@Algorithm);
            }
            computedDigest.Init(AVMPlusDigest.DIGESTMETHOD_SHA256);
            transforms = oneRef.XML_DSIG_NS::Transforms.XML_DSIG_NS::Transform;
            result = this.m_uriDereferencer.dereference(oneRef.@URI);
            if(result == null)
            {
               throw new Error("IURIDereferencer.dereference() returned null",kNullPointerError);
            }
            if(transforms.length() > MAX_NUM_TRANSFORMS)
            {
               throw new Error("too many transforms to process");
            }
            if(transforms != null && transforms.length() > 0)
            {
               for each(oneTransform in transforms)
               {
                  if(oneTransform.@Algorithm == XML_TRANSFORM_C14N)
                  {
                     resultString = result.readUTFBytes(result.bytesAvailable);
                     xmlResult = new XML(resultString);
                     newResult = new ByteArray();
                     newResult.writeUTFBytes(c14ner.CanonicalizeXML(xmlResult));
                     result = newResult;
                  }
                  else
                  {
                     if(oneTransform.@Algorithm != XML_TRANSFORM_ENVELOPED_SIGNATURE)
                     {
                        throw new Error("unsupported XML transform: " + oneTransform.@Algorithm);
                     }
                     resultString = result.readUTFBytes(result.bytesAvailable);
                     containingDoc = new XML(resultString);
                     transformer = this.constructEnvelopedTransformer();
                     docMinusSig = transformer.transform(signature,containingDoc);
                     newResult = new ByteArray();
                     newResult.writeUTFBytes(c14ner.CanonicalizeXML(docMinusSig));
                     result = newResult;
                  }
               }
            }
            computedDigest.Update(result);
            if(computedDigest.FinishDigest(xmlDigest) != 0)
            {
               allRefValid = false;
            }
         }
         return allRefValid;
      }
      
      public function verify(signature:XML) : void
      {
         try
         {
            this.verifyCommon(signature);
         }
         catch(e:Error)
         {
            m_isValidating = false;
            throw e;
         }
         this.m_cryptContext.addEventListener(Event.COMPLETE,function(event:Event):void
         {
            var error:Error = null;
            try
            {
               validateReferences(signature);
            }
            catch(e:Error)
            {
               error = e;
            }
            m_isValidating = false;
            if(error != null)
            {
               m_referenceStatus = SignatureStatus.INVALID;
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,error.message,error.errorID));
            }
            else
            {
               dispatchEvent(new Event(Event.COMPLETE));
            }
         });
         this.m_cryptContext.addEventListener(ErrorEvent.ERROR,function(event:Event):void
         {
            m_isValidating = false;
            dispatchEvent(event.clone());
         });
         this.m_cryptContext.VerifySigASync(this.m_sigValueString,this.m_signedDataString,this._ignoreCertTime);
      }
      
      private function validateReferences(signature:XML) : void
      {
         var idIsOK:Boolean = false;
         var digestStatus:String = this.cryptContextCodeToStatus(this.m_cryptContext.getDataTBVStatus());
         var identityStatus:String = this.cryptContextCodeToStatus(this.m_cryptContext.getIDStatus());
         idIsOK = false;
         if(this.m_referencesValidationSetting != NEVER)
         {
            idIsOK = false;
            if(this.m_referencesValidationSetting == VALID_OR_UNKNOWN_IDENTITY)
            {
               idIsOK = identityStatus != SignatureStatus.INVALID;
            }
            else
            {
               idIsOK = identityStatus == SignatureStatus.VALID;
            }
            if(idIsOK)
            {
               try
               {
                  if(this.verifyReferences(signature))
                  {
                     this.m_referenceStatus = SignatureStatus.VALID;
                  }
                  else
                  {
                     this.m_referenceStatus = SignatureStatus.INVALID;
                  }
               }
               catch(e:Error)
               {
                  m_referenceStatus = SignatureStatus.INVALID;
                  throw e;
               }
            }
         }
      }
      
      private function verifyCommon(signature:XML) : void
      {
         this.throwIfValidating();
         this.m_isValidating = true;
         this.m_referenceStatus = SignatureStatus.UNKNOWN;
         var signedData:XML = XML(signature.XML_DSIG_NS::SignedInfo);
         var sigValue:XMLList = signature.XML_DSIG_NS::SignatureValue;
         if(signedData.XML_DSIG_NS::CanonicalizationMethod.@Algorithm != XML_TRANSFORM_C14N)
         {
            this.m_isValidating = false;
            throw new Error("Unsupported canonicalization method: " + signedData.XML_DSIG_NS::CanonicalizationMethod.@Algorithm);
         }
         this.readSigKeyInfo(signature);
         var c14ner:XMLCanonicalizer = this.constructXMLCanonicalizer();
         this.m_signedDataString = c14ner.CanonicalizeXML(signedData);
         this.m_sigValueString = sigValue.toString();
         this.verifyTimestamp(signature);
      }
      
      private function verifyTimestamp(signature:XML) : void
      {
         var sigValue:XMLList;
         var sigValueBytes:ByteArray;
         var xmlTimestamp:XML = null;
         var foundUri:Boolean = false;
         var tsUri:String = null;
         var okUris:Array = null;
         var selector:Function = null;
         var selected:Array = null;
         var timestampToken:XMLList = null;
         var timestampTokenBase64:String = null;
         var transforms:XMLList = null;
         var transformedSigValue:IDataInput = null;
         var transformedSigValueString:String = null;
         var xades:Namespace = new Namespace(XML_XADES_NAMESPACE);
         var xmlTimestamps:XMLList = signature.XML_DSIG_NS::Object.xades::QualifyingProperties.xades::UnsignedProperties.xades::UnsignedSignatureProperties.xades::SignatureTimeStamp.xades::HashDataInfo;
         if(xmlTimestamps == null)
         {
            return;
         }
         sigValue = signature.XML_DSIG_NS::SignatureValue;
         if(sigValue.length() == 0)
         {
            return;
         }
         sigValueBytes = new ByteArray();
         sigValueBytes.writeUTFBytes(sigValue[0].toXMLString());
         sigValueBytes.position = 0;
         for each(xmlTimestamp in xmlTimestamps)
         {
            foundUri = false;
            tsUri = xmlTimestamp.@uri;
            okUris = this.m_timestampUris;
            selector = function(item:*, index:int, array:Array):*
            {
               return item == tsUri;
            };
            selected = okUris.filter(selector);
            foundUri = selected.length > 0;
            if(foundUri)
            {
               timestampToken = xmlTimestamp.xades::EncapsulatedTimeStamp;
               if(timestampToken != null && timestampToken.length() == 1)
               {
                  timestampTokenBase64 = timestampToken[0].toString();
                  transforms = xmlTimestamp.XML_DSIG_NS::Transforms.XML_DSIG_NS::Transform;
                  transformedSigValue = this.applyTransforms(sigValueBytes,transforms,signature);
                  transformedSigValueString = transformedSigValue.readUTFBytes(transformedSigValue.bytesAvailable);
                  this.m_cryptContext.verifyTimestamp(timestampTokenBase64,transformedSigValueString,this._ignoreCertTime);
                  if(this.m_cryptContext.verificationTime != 0)
                  {
                     break;
                  }
               }
            }
         }
      }
      
      private function readSigKeyInfo(signature:XML) : void
      {
         var certificate:XMLList = null;
         var crls:XMLList = null;
         var oneEmbeddedCert:XML = null;
         var oneEmbeddedCRL:XML = null;
         var signerDN:XMLList = null;
         var certString:String = null;
         try
         {
            certificate = signature.XML_DSIG_NS::KeyInfo.XML_DSIG_NS::X509Data.XML_DSIG_NS::X509Certificate;
            crls = signature.XML_DSIG_NS::KeyInfo.XML_DSIG_NS::X509Data.XML_DSIG_NS::X509CRL;
            for each(oneEmbeddedCert in certificate)
            {
               this.m_cryptContext.addChainBuildingCertBase64(oneEmbeddedCert.toString(),false);
            }
            for each(oneEmbeddedCRL in crls)
            {
               this.m_cryptContext.addCRLRevEvidenceBase64(oneEmbeddedCRL.toString());
            }
         }
         catch(e:Error)
         {
            throw new Error("Encountered an error while parsing KeyInfo.X509Data ");
         }
         try
         {
            signerDN = signature.XML_DSIG_NS::KeyInfo.XML_DSIG_NS::X509Data.XML_DSIG_NS::X509SubjectName;
            certString = certificate[0].toString();
            if(signerDN != null && signerDN.length() > 0)
            {
               this.m_cryptContext.setSignerCertDN(signerDN[0].toString());
            }
            else
            {
               this.m_cryptContext.setSignerCert(certString);
            }
         }
         catch(e:Error)
         {
            throw new Error("Encountered an error while parsing signer\'s certificate");
         }
      }
      
      private function _verifySync(signature:XML) : void
      {
         try
         {
            this.verifyCommon(signature);
            this.m_cryptContext.VerifySigSync(this.m_sigValueString,this.m_signedDataString,this._ignoreCertTime);
            this.validateReferences(signature);
         }
         catch(e:Error)
         {
            m_isValidating = false;
            throw e;
         }
         this.m_isValidating = false;
      }
      
      private function _setTimestampUris(uris:Array) : void
      {
         this.m_timestampUris = uris;
      }
      
      private function _setUseCodeSigningValidationRules() : void
      {
         this.m_cryptContext.useCodeSigningValidationRules();
         this.m_referencesValidationSetting = VALID_OR_UNKNOWN_IDENTITY;
      }
      
      private function _addTimestampingRoot(rootCert:ByteArray) : void
      {
         this.m_cryptContext.addTimestampingRootRaw(rootCert);
      }
      
      private function _setTimestampRevocationCheckSetting(setting:String) : void
      {
         this.throwIfValidating();
         this.m_cryptContext.setTimestampRevCheckSetting(setting);
      }
      
      private function getTimestampRevocationCheckSetting() : String
      {
         return this.m_cryptContext.getTimestampRevCheckSetting();
      }
      
      private function getCryptContext() : CryptContext
      {
         return this.m_cryptContext;
      }
      
      public function get signerCN() : String
      {
         return this.m_cryptContext.signerCN;
      }
      
      public function get signerDN() : String
      {
         return this.m_cryptContext.signerDN;
      }
      
      private function _getPublicKey(signature:XML) : ByteArray
      {
         var cert:XMLList = null;
         var result:ByteArray = null;
         try
         {
            cert = signature.XML_DSIG_NS::KeyInfo.XML_DSIG_NS::X509Data.XML_DSIG_NS::X509Certificate;
            result = this.m_cryptContext.getPublicKey(cert[0].toString());
         }
         catch(e:Error)
         {
            throw new Error("Encountered an error while parsing KeyInfo.X509Data ");
         }
         return result;
      }
      
      private function _getSignerValidEndTime() : uint
      {
         return this.m_cryptContext.signerValidEnd;
      }
      
      private function _getVerificationTime() : uint
      {
         return this.m_cryptContext.verificationTime;
      }
      
      private function _getSignerIDSummary(version:uint) : String
      {
         return this.m_cryptContext.getSignerIDSummary(version);
      }
      
      private function _guessSignerIDSummary(signature:XML, version:uint) : String
      {
         this.readSigKeyInfo(signature);
         return this.m_cryptContext.getIDSummaryFromSigChain(version);
      }
      
      private native function constructAVMPlusDigest() : AVMPlusDigest;
      
      private native function constructCryptContext() : CryptContext;
      
      private native function constructXMLCanonicalizer() : XMLCanonicalizer;
      
      private native function constructEnvelopedTransformer() : XMLSignatureEnvelopedTransformer;
      
      private function _setIgnoreCertTime(ignoreCertTime:Boolean) : void
      {
         this._ignoreCertTime = ignoreCertTime;
      }
      
      private function initStubProperties() : void
      {
         this.stubProperties = new Object();
      }
      
      private function setStubProperty(key:String, value:*) : *
      {
         this.stubProperties[key] = value;
      }
      
      private function getStubProperty(key:String) : *
      {
         return this.stubProperties[key];
      }
   }
}

