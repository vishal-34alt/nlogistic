package model;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.UUID;
import javax.servlet.http.Part;

/** Private evidence storage: never accept a submitted absolute path or write into webapp. */
public final class ClaimEvidenceStorage {
    private static final long MAX_SIZE = 10L * 1024L * 1024L;
    private final Path directory;

    public ClaimEvidenceStorage() throws IOException {
        String custom=System.getProperty("nlogistic.claim.uploadDir");
        String root=System.getProperty("catalina.base",System.getProperty("user.home"));
        directory=(custom!=null&&!custom.trim().isEmpty()?Paths.get(custom):Paths.get(root,"nlogistic-claim-evidence"))
                   .toAbsolutePath().normalize();
        Files.createDirectories(directory);
    }
    public static final class UploadedFile {
        public final String displayName;
        public final String storedName;
        public final String type;
        public UploadedFile(String displayName,String storedName,String type){
            this.displayName=displayName;this.storedName=storedName;this.type=type;
        }
    }
    public UploadedFile save(Part part) throws IOException {
        if(part==null||part.getSize()<=0)throw new IllegalArgumentException("Choose an evidence file.");
        if(part.getSize()>MAX_SIZE)throw new IllegalArgumentException("Evidence must be at most 10 MB.");
        String original=part.getSubmittedFileName();
        if(original==null)throw new IllegalArgumentException("Evidence filename is missing.");
        original=original.replace('\\','/');original=original.substring(original.lastIndexOf('/')+1).trim();
        original=original.replaceAll("[\\p{Cntrl}/\\\\]", "_");
        if(original.isEmpty()||original.length()>150)throw new IllegalArgumentException("Evidence filename must be 1–150 characters.");
        int dot=original.lastIndexOf('.');
        if(dot<1||dot==original.length()-1)throw new IllegalArgumentException("Evidence must be PDF, JPG or PNG.");
        String ext=original.substring(dot+1).toUpperCase(Locale.ROOT);
        if("JPEG".equals(ext))ext="JPG";
        if(!("PDF".equals(ext)||"JPG".equals(ext)||"PNG".equals(ext)))
            throw new IllegalArgumentException("Evidence must be PDF, JPG or PNG.");
        String stored=UUID.randomUUID().toString().replace("-", "")+"."+ext.toLowerCase(Locale.ROOT);
        Path target=directory.resolve(stored);
        try(InputStream in=part.getInputStream()){
            Files.copy(in,target);
        }
        try {
            byte[] head=new byte[8];int count;
            try(InputStream in=Files.newInputStream(target)){count=in.read(head);}
            boolean valid=("PDF".equals(ext)&&count>=4&&head[0]=='%'&&head[1]=='P'&&head[2]=='D'&&head[3]=='F')
                ||("JPG".equals(ext)&&count>=3&&(head[0]&255)==255&&(head[1]&255)==216&&(head[2]&255)==255)
                ||("PNG".equals(ext)&&count>=8&&(head[0]&255)==137&&head[1]=='P'&&head[2]=='N'&&head[3]=='G'
                   &&(head[4]&255)==13&&(head[5]&255)==10&&(head[6]&255)==26&&(head[7]&255)==10);
            if(!valid)throw new IllegalArgumentException("The file content does not match its PDF, JPG or PNG extension.");
            return new UploadedFile(original,stored,ext);
        } catch (IOException|RuntimeException e) {
            Files.deleteIfExists(target);throw e;
        }
    }
    public Path read(String storedName) {
        if(storedName==null||!storedName.matches("[0-9a-f]{32}\\.(?:pdf|jpg|png)"))
            throw new IllegalArgumentException("This evidence was stored by an older module version; its file path is not available for secure download.");
        return directory.resolve(storedName);
    }
    /** Return only an authorized, validated stored document. Authentication remains in the controller/model actions. */
    public byte[] loadDocument(String storedName) throws IOException {
        Path file = read(storedName);
        if (!Files.isRegularFile(file)) throw new IllegalArgumentException("This evidence file is no longer available on the server.");
        if (Files.size(file) > MAX_SIZE) throw new IOException("Evidence exceeds the configured upload limit.");
        return Files.readAllBytes(file);
    }
    public void discard(String storedName) throws IOException {
        if(storedName!=null&&storedName.matches("[0-9a-f]{32}\\.(?:pdf|jpg|png)"))
            Files.deleteIfExists(directory.resolve(storedName));
    }
}
