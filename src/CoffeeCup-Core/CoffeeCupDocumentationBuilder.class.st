Class {
	#name : #CoffeeCupDocumentationBuilder,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupDocumentationBuilder class >> on: stream [

	^ self new
		  setStream: stream;
		  yourself
]

{ #category : #initialization }
CoffeeCupDocumentationBuilder >> setStream: aStream [
stream := aStream
]

{ #category : #visiting }
CoffeeCupDocumentationBuilder >> visit: anObject [

	^ anObject acceptVisitor: self
]

{ #category : #visiting }
CoffeeCupDocumentationBuilder >> visitApi: aCoffeeCupApi [

	stream
		nextPutAll: '# [';
		nextPutAll: aCoffeeCupApi title;
		nextPutAll: '](';
		print: aCoffeeCupApi url;
		nextPut: $);
		cr;
		cr.
	stream
		nextPutAll: aCoffeeCupApi description;
		cr;
		cr.

	aCoffeeCupApi pathParameters ifNotEmpty: [ 
		stream
			nextPutAll: '## Path Parameters';
			cr;
			cr.
		stream
			nextPutAll: 'Path: `';
			print: aCoffeeCupApi fullPath;
			nextPutAll: '`';
			cr;
			cr.

		aCoffeeCupApi pathParameters do: [ :parameter | 
			self visit: parameter ] ].

	aCoffeeCupApi queryParameters ifNotEmpty: [ 
		stream
			nextPutAll: '## Query Parameters';
			cr;
			cr.

		aCoffeeCupApi queryParameters do: [ :parameter | 
			self visit: parameter ] ].
	
	(aCoffeeCupApi children sorted: [ :x :y | x name < y name ]) do: [ 
		:each | self visit: each ]
]

{ #category : #visiting }
CoffeeCupDocumentationBuilder >> visitEndpoint: aCoffeeCupEndpoint [

	stream
		nextPutAll: '# ' , aCoffeeCupEndpoint title;
		cr;
		cr.

	aCoffeeCupEndpoint description ifNotNil: [ 
		stream
			nextPutAll: aCoffeeCupEndpoint description;
			cr;
			cr ].

	aCoffeeCupEndpoint pathParameters ifNotEmpty: [ 
		stream
			nextPutAll: '## Path Parameters';
			cr;
			cr.
		stream
			nextPutAll: 'Path: `';
			print: aCoffeeCupEndpoint fullPath;
			nextPutAll: '`';
			cr;
			cr.

		aCoffeeCupEndpoint pathParameters do: [ :parameter | 
			self visit: parameter ] ].

	aCoffeeCupEndpoint queryParameters ifNotEmpty: [ 
		stream
			nextPutAll: '## Query Parameters';
			cr;
			cr.

		aCoffeeCupEndpoint queryParameters do: [ :parameter | 
			self visit: parameter ] ]
]

{ #category : #visiting }
CoffeeCupDocumentationBuilder >> visitNamespace: aCoffeeCupNamespace [

	stream
		nextPutAll: '# ' , aCoffeeCupNamespace title;
		cr;
		cr.

	aCoffeeCupNamespace description ifNotNil: [ 
		stream
			nextPutAll: aCoffeeCupNamespace description;
			cr;
			cr ].

	aCoffeeCupNamespace pathParameters ifNotEmpty: [ 
		stream
			nextPutAll: '## Path Parameters';
			cr;
			cr.
		stream
			nextPutAll: 'Path: `';
			print: aCoffeeCupNamespace fullPath;
			nextPutAll: '`';
			cr;
			cr.

		aCoffeeCupNamespace pathParameters do: [ :parameter | 
			self visit: parameter ] ].

	aCoffeeCupNamespace queryParameters ifNotEmpty: [ 
		stream
			nextPutAll: '## Query Parameters';
			cr;
			cr.

		aCoffeeCupNamespace queryParameters do: [ :parameter | 
			self visit: parameter ] ].

	aCoffeeCupNamespace children do: [ :each | self visit: each ]
]

{ #category : #visiting }
CoffeeCupDocumentationBuilder >> visitParameter: aCoffeeCupParameter [

	stream
		nextPutAll: '* `';
		nextPutAll: aCoffeeCupParameter name;
		nextPutAll: '`:'.

	aCoffeeCupParameter description ifNotNil: [ 
		stream
			space;
			print: aCoffeeCupParameter description ].

	aCoffeeCupParameter default ifNotNil: [ 
		stream space
			nextPutAll: '(Default value `';
			nextPutAll: aCoffeeCupParameter default;
			nextPutAll: '`)' ].
	stream
		cr;
		cr
]

{ #category : #visiting }
CoffeeCupDocumentationBuilder >> visitPathParameter: aCoffeeCupPathParameter [

self visitParameter: aCoffeeCupPathParameter 
]
