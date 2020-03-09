package fr.istic.tools.scanexam.utils

import fr.istic.tools.scanexam.ScanexamFactory
import fr.istic.tools.scanexam.Question
import java.util.List
import fr.istic.tools.scanexam.Exam
import java.io.File
import java.io.FilenameFilter
import boofcv.alg.fiducial.qrcode.QrCode;
import boofcv.factory.fiducial.FactoryFiducial;
import boofcv.io.UtilIO;
import boofcv.io.image.ConvertBufferedImage;
import boofcv.io.image.UtilImageIO;
import boofcv.struct.image.GrayU8;
import java.util.ArrayList
import java.util.StringTokenizer

class ScanExamXtendFactory {
	
	def  static exam(String title) {
		val e= ScanexamFactory.eINSTANCE.createExam
		e.label = title
		e
	}

	def static exam(String title, String path, int nPages, String templatepath, List<String> students) {
		val e= exam(title)

		e.numberOfPages= nPages
		e.folderPath=path
		e.questions+=#[]
		e.scale = 2;
		val images = new ArrayList<File>()
		val File dir = new File(templatepath);
		images+= dir.listFiles(new FilenameFilter() {
			override boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(".png");
			}
		}).sortInplace([File a, File b | a.name.compareTo(b.name)]);
		
		images.forEach([image | {
			val input = UtilImageIO.loadImage(UtilIO.pathExample(image.absolutePath));
			val gray = ConvertBufferedImage.convertFrom(input,null as GrayU8);
			val detector = FactoryFiducial.qrcode(null, GrayU8);
			detector.process(gray);
			val detections = detector.getDetections();
			for( QrCode qr : detections ) {
				val s = new StringTokenizer(qr.message, ":")
				//1928:3821:16999:2237:1:1
				val x1 = Double.parseDouble(s.nextToken)
				val y1 = Double.parseDouble(s.nextToken)
				val w = Double.parseDouble(s.nextToken)
				val h = Double.parseDouble(s.nextToken)
				val name = s.nextToken
				val page = Double.parseDouble(s.nextToken)
				var xx1 = -1
				var xx2 = -1
				var yy1 =-1
				var yy2 = -1
				
				for (v: qr.bounds.vertexes.data)					
					{
						if (xx1 == -1 || xx1 > v.x)
							xx1 = v.x.intValue - 10							
						if (yy1 == -1 || yy1 > v.y)
							yy1 = v.y.intValue -10								
						if (xx2 == -1 || xx2 < v.x)
							xx2 = v.x.intValue + 1							
						if (yy2 == -1 || yy2 <  v.y)
							yy2 = v.y.intValue +1								
					}
					val ratiox = xx1 / (x1 + w) 					
					val ratioy = yy1 / (y1)
					if (qr == detections.get(0) && images.get(0) == image){
						e.questions += question(name,#[(x1 * ratiox).intValue,(y1 * ratioy).intValue,((x1+w) * ratiox).intValue, ((y1+h) * ratioy).intValue,page.intValue], #[(y1 * ratioy).intValue + 30,180,(y1 * ratioy).intValue + 80,160,0], students,0 )				 						
					}else{
						e.questions += question(name,#[(x1 * ratiox).intValue,(y1 * ratioy).intValue,((x1+w) * ratiox).intValue, ((y1+h) * ratioy).intValue,page.intValue], #[(y1 * ratioy).intValue + 30,180,(y1 * ratioy).intValue + 80,160,0], #["A", "B","C", "D","E", "F"],0 )				 
						
					} 					
			}
		}])		
		
		e
	}


	def static exam(String title, String path, int nPages, int scale, Iterable<Question> questions) {
		val e= exam(title)

		e.numberOfPages= nPages
		e.scale=scale
		e.folderPath=path
		e.questions+=questions
		e
	}
 

	def static gradingData(Exam exam) {
		
		val e= ScanexamFactory.eINSTANCE.createGradingData
		e.excelFileName = exam.label+".xls"
		e.exam =  exam
		val File dir = new File(exam.folderPath);
		e.images+= dir.listFiles(new FilenameFilter() {
			override boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(".png");
			}
		}).sortInplace([File a, File b | a.name.compareTo(b.name)]);
//		println(e.images.size)
//		println(exam.numberOfPages)
		
		if (e.images.size%exam.numberOfPages!=0) {
			throw new UnsupportedOperationException('''Uneven number of scans ''')
		}
		println("Nb images "+e.images.size)
		val int nbStudents= e.images.size/exam.numberOfPages
		for (i:0..<nbStudents) {
			val grade = studentGrade
			grade.studentID="student_"+i
			e.grades+=grade
			for (q : exam.questions) {
				val questionGrade = questionGrade(q)
				grade.questionGrades+= questionGrade
				questionGrade.filename=e.images.get(i*exam.numberOfPages+ q.zone.page-1).path
			}
		}
		e
	}


	def static studentGrade() {
		ScanexamFactory.eINSTANCE.createStudentGrade
	
	}

	def static questionGrade(Question q) {
		val e= ScanexamFactory.eINSTANCE.createQuestionGrade
		e.question=q
		e.grade=""
		e.validated=false
		e
	}

	def static question(String label) {  
		val r =ScanexamFactory.eINSTANCE.createQuestion
		r.label=label
		r  
	}
 
	def static question(String label, List<Integer> z,List<Integer> markZ, List<String> grades, int defaultGrade) {
		val r =question(label)
		r.zone=zone(z.get(0),z.get(1),z.get(2)-z.get(0),z.get(3)-z.get(1),z.get(4))
		r.markZone=zone(markZ.get(0),markZ.get(1),markZ.get(2)-markZ.get(0),markZ.get(3)-markZ.get(1),markZ.get(4))
		r.grades+=grades
		r.defaultGradeIndex=defaultGrade
		r
	}



	def static zone(int x, int y, int w, int h, int page) {
		val r = ScanexamFactory.eINSTANCE.createScanZone
		r.x=x
		r.y=y
		r.w=w
		r.h=h
		r.page=page
		r
	}

}