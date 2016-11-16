import plyfile
import os
import os.path
import sys
import numpy
import itertools
import numpy.linalg
import scipy.io
import scipy.sparse
NUM_DIR = 8

class GraphData(object):

	def __init__(self):
		self.vertexCount = 0
		self.V = []
		self.vertexLock = False

	def addVertex(self,vertex):
		if not self.vertexLock:
			#print(numpy.array((vertex['x'],vertex['y'],vertex['z'])))
			self.vertexCount += 1
			self.V.append(numpy.array((vertex['x'],vertex['y'],vertex['z'])))
		
	def lockVertices(self):
		self.vertexLock = True
		self.A = []
		for i in range(NUM_DIR):
			self.A.append(numpy.zeros((self.vertexCount,self.vertexCount),dtype=numpy.bool_))
		
	#Inspired by Python's "pairwise" recipe, but creates a cycle
	def __edgeIter(self,face):
		faceCycle = numpy.append(face[0],face[0][0])
		a,b = itertools.tee(faceCycle)
		next(b,None)
		return itertools.izip(a,b)
		
	def addFace(self,face):
		for i,j in self.__edgeIter(face):
			#edgeLen = 1./numpy.linalg.norm(self.V[i] - self.V[j],2).astype(numpy.float32)
			#Let's try this for simplicity, the information should theoretically
			#be in the nodes
			#Ignore edges on the -z axis
			if V[i][2] >= 0 and V[j][2] >=0:
				zindex = numpy.dot([4,2,1],numpy.greater((self.V[i] - self.V[j]),numpy.zeros(3)));
				edgeLen = 1
				#print('From {0} to {1}: Len {2}',i,j,edgeLen)
				self.A[zindex][i,j] = edgeLen	
				self.A[zindex][j,i] = edgeLen	
		
	def saveAsMat(self,fileOut):
		#Need to compress otherwise each sample is way too big!
		for i in range(NUM_DIR):
			self.A[i] = scipy.sparse.coo_matrix(self.A[i])
		scipy.io.savemat(fileOut,mdict={'vCount':self.vertexCount,'V':numpy.asarray(self.V,dtype=numpy.float32),'A':self.A},do_compression=True)
		

def ply2graph(plyPath):
	plydata = plyfile.PlyData.read(plyPath)
	graphData = GraphData()
	for i in range(plydata['vertex'].count):
		graphData.addVertex(plydata['vertex'][i])
	graphData.lockVertices()
	for i in range(plydata['face'].count):
		#print(plydata['face'][i])
		graphData.addFace(plydata['face'][i])
	return graphData
	
def Main():
	if len(sys.argv) > 2 and os.path.isdir(sys.argv[1]):
		dirFiles = [f for f in os.listdir(sys.argv[1]) if os.path.isfile(os.path.join(sys.argv[1], f))]
		if not os.path.isdir(sys.argv[2]):
			os.mkdir(sys.argv[2])
		for dirFile in dirFiles:
			fname,ext = os.path.splitext(dirFile)
			if ext == '.ply' and not os.path.isfile(sys.argv[2] + '/' + fname + '.mat'):
				graphData = ply2graph(os.path.join(sys.argv[1], dirFile))
				graphData.saveAsMat(sys.argv[2] + '/' + fname + '.mat')
	else:
		print('Could not find path!')
		
	
Main()

	