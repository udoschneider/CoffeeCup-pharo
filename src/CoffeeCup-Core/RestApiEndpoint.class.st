Class {
	#name : #RestApiEndpoint,
	#superclass : #Object,
	#instVars : [
		'api',
		'name',
		'path',
		'parameters'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
RestApiEndpoint class >> api: anApi name: aSymbol [

	^ self new
		  setApi: anApi name: aSymbol;
		  yourself
]

{ #category : #'as yet unclassified' }
RestApiEndpoint >> _parameter: parameter required: aBoolean default: defaultValue [

	parameters add: (RestApiQueryParameter
			 key: parameter asRestApiSelector
			 name: parameter
			 required: aBoolean
			 default: defaultValue)
]

{ #category : #accessing }
RestApiEndpoint >> allParameters [

	^ api parameters, parameters 
]

{ #category : #accessing }
RestApiEndpoint >> allPathParameters [

	^ self allParameters select: #isPathParameter  
	
]

{ #category : #accessing }
RestApiEndpoint >> allQueryParameters [

	^ self allParameters select: #isQueryParameter
]

{ #category : #'as yet unclassified' }
RestApiEndpoint >> call: method with: arguments [

	| mappedPath url request |
	mappedPath := self mappedPath: arguments.
	url := api baseUrl / mappedPath.
	
	(self mappedQueryParameters: arguments) keysAndValuesDo: [ :key :value | 
		url queryAt: key put: value ].

	request := ZnRequest
		           method: method asRestApiSelector asUppercase
		           url: url.

	^ api request: request
]

{ #category : #'reflective operations' }
RestApiEndpoint >> doesNotUnderstand: aMessage [

	| selector |
	selector := aMessage selector.

	^ selector isRestApiCall
		  ifTrue: [ 
			  self call: selector restApiMethod with: (OrderedDictionary
					   newFromKeys: selector restApiArgs
					   andValues: aMessage arguments) ]
		  ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #initialization }
RestApiEndpoint >> initialize [

	super initialize.
	parameters := Set new
]

{ #category : #'as yet unclassified' }
RestApiEndpoint >> mappedPath: arguments [

	^ self path format: (self mappedPathParameters: arguments)
]

{ #category : #'as yet unclassified' }
RestApiEndpoint >> mappedPathParameters: arguments [

	| mapped |
	mapped := Dictionary new.
	self allParameters select: #isPathParameter thenDo: [ :parameter | 
		parameter isRequired
			ifTrue: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ]
					ifAbsent: [ 
						parameter default
							ifNotNil: [ :defaultValue | 
							mapped at: parameter name put: defaultValue ]
							ifNil: [ RestApiError signalMissingArgument: parameter ] ] ]
			ifFalse: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ] ] ].
	^ mapped
]

{ #category : #'as yet unclassified' }
RestApiEndpoint >> mappedQueryParameters: arguments [

	| mapped |
	mapped := Dictionary new.
	self allParameters select: #isQueryParameter thenDo: [ :parameter | 
		parameter isRequired
			ifTrue: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ]
					ifAbsent: [ 
						parameter default
							ifNotNil: [ :defaultValue | 
							mapped at: parameter name put: defaultValue ]
							ifNil: [ RestApiError signalMissingArgument: parameter ] ] ]
			ifFalse: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ] ] ].
	^ mapped
]

{ #category : #'as yet unclassified' }
RestApiEndpoint >> parameter: aString [

^	parameters add:
		(RestApiQueryParameter key: aString asRestApiSelector name: aString)
]

{ #category : #accessing }
RestApiEndpoint >> parameters [

	^ parameters
]

{ #category : #accessing }
RestApiEndpoint >> path [

	^ path ifNil: [ name asSymbol ]
]

{ #category : #initialization }
RestApiEndpoint >> path: aString [


	path := aString.

	path restApiFormatParameters do: [ :pathParameter | 
		parameters add: (RestApiPathParameter
				 key: pathParameter asRestApiSelector
				 name: pathParameter) ]
]

{ #category : #initialization }
RestApiEndpoint >> setApi: anApi name: aSymbol [

	api := anApi.
	name := aSymbol.
	
]

{ #category : #'instance creation' }
RestApiEndpoint >> with: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ].
]
