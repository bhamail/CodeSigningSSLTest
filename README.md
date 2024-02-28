Test of Java Application Signing using SSL.com tooling
======================================================

Steps taken to setup this project.

1. I added the [maven-wrapper](https://maven.apache.org/wrapper/) so you don't need to worry about fiddling much with 
   Maven. Just use `./mvnw` where you'd normally use `mvn`.
2. For reference only: DO NOTE EXECUTE THIS STEP: The test Java application source code was generated using the
   [Maven Archetype - Simple](https://maven.apache.org/guides/introduction/introduction-to-archetypes.html).

   <details>
   
   ```shell
   mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-simple
   ```
   </details>
3. You will find your choice of JDK "matters(tm)". JDK 8 and JDK 17 had no joy. 
   I had more success with JDK 11. I used [sdkman](https://sdkman.io) to run with JDK 11 like so:

   ```shell
   sdk use java 11.0.17-zulu  
   ```
   Verify your jdk version via:

   ```shell
   java -version  
   ```

   <details>
      <summary>Command Output</summary>
   
   ```shell
   $ java -version
    openjdk version "11.0.17" 2022-10-18 LTS
    OpenJDK Runtime Environment Zulu11.60+19-CA (build 11.0.17+8-LTS)
    OpenJDK 64-Bit Server VM Zulu11.60+19-CA (build 11.0.17+8-LTS, mixed mode)
   ```
   </details>

4. The CodeSignTool was downloaded via  [Linux and macOS](https://www.ssl.com/download/codesigntool-for-linux-and-macos/)
   from [eSigner CodeSignTool Command Guide](https://www.ssl.com/guide/esigner-codesigntool-command-guide/). The 
   zip file contents where extracted to [CodeSignTool-v1.3.0](CodeSignTool-v1.3.0).
5. The file: [CodeSignTool-v1.3.0/conf/code_sign_tool.properties](CodeSignTool-v1.3.0/conf/code_sign_tool.properties) 
   has been edited as per [eSigner Demo Credentials and Certificates](https://www.ssl.com/guide/esigner-demo-credentials-and-certificates/#ftoc-heading-1).

   NOTE: Be sure you setup a One Time Password according to `Demo QR Codes and TOTP Secrets` in the article because you 
   will need to enter the One Time Password when you sign the jar. 
   
   [Automate eSigner EV Code Signing](https://www.ssl.com/how-to/automate-esigner-ev-code-signing/) shows how to 
   automate this OTP process for CI.
6. Build the application jar to be signed using:
   
   ```shell
   cd cool-app/
   ./mvnw clean package
   ```

   <details>
      <summary>Command Output</summary>

   ```shell
   $ cd cool-app/
   $ .$ ./mvnw clean package
   [INFO] Scanning for projects...
   [INFO]
   [INFO] -----------------------< com.sonatype:cool-app >------------------------
   [INFO] Building cool-app 1.0-SNAPSHOT
   [INFO]   from pom.xml
   [INFO] --------------------------------[ jar ]---------------------------------
   [INFO]
   [INFO] --- clean:3.1.0:clean (default-clean) @ cool-app ---
   [INFO]
   [INFO] --- resources:3.0.2:resources (default-resources) @ cool-app ---
   [INFO] Using 'UTF-8' encoding to copy filtered resources.
   [INFO] skip non existing resourceDirectory /Users/bhamail/sonatype/sasq/CodeSigningSSLTest/cool-app/src/main/resources
   [INFO]
   [INFO] --- compiler:3.8.0:compile (default-compile) @ cool-app ---
   [INFO] Changes detected - recompiling the module!
   [INFO] Compiling 1 source file to /Users/bhamail/sonatype/sasq/CodeSigningSSLTest/cool-app/target/classes
   [INFO]
   [INFO] --- resources:3.0.2:testResources (default-testResources) @ cool-app ---
   [INFO] Using 'UTF-8' encoding to copy filtered resources.
   [INFO] skip non existing resourceDirectory /Users/bhamail/sonatype/sasq/CodeSigningSSLTest/cool-app/src/test/resources
   [INFO]
   [INFO] --- compiler:3.8.0:testCompile (default-testCompile) @ cool-app ---
   [INFO] Changes detected - recompiling the module!
   [INFO] Compiling 1 source file to /Users/bhamail/sonatype/sasq/CodeSigningSSLTest/cool-app/target/test-classes
   [INFO]
   [INFO] --- surefire:2.22.1:test (default-test) @ cool-app ---
   [INFO]
   [INFO] -------------------------------------------------------
   [INFO]  T E S T S
   [INFO] -------------------------------------------------------
   [INFO] Running com.sonatype.AppTest
   [INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.005 s - in com.sonatype.AppTest
   [INFO]
   [INFO] Results:
   [INFO]
   [INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
   [INFO]
   [INFO]
   [INFO] --- jar:3.0.2:jar (default-jar) @ cool-app ---
   [INFO] Building jar: /Users/bhamail/sonatype/sasq/CodeSigningSSLTest/cool-app/target/cool-app-1.0-SNAPSHOT.jar
   [INFO] ------------------------------------------------------------------------
   [INFO] BUILD SUCCESS
   [INFO] ------------------------------------------------------------------------
   [INFO] Total time:  1.974 s
   [INFO] Finished at: 2024-02-28T11:40:56-05:00
   [INFO] ------------------------------------------------------------------------
   ```
   </details>
7. Sign the jar you just built using the following:

   Change to the tool directory:
   ```shell
   cd ..
   cd CodeSignTool-v1.3.0
   ./CodeSignTool.sh sign -credential_id=8b072e22-7685-4771-b5c6-48e46614915f -username=esigner_demo -password="esignerDemo#1" -input_file_path=../cool-app/target/cool-app-1.0-SNAPSHOT.jar -output_dir_path=../signed/ 
   ```
   Run the signing tool. You will be prompted to enter the OTP.
   ```shell
   ./CodeSignTool.sh sign -credential_id=8b072e22-7685-4771-b5c6-48e46614915f -username=esigner_demo -password="esignerDemo#1" -input_file_path=../cool-app/target/cool-app-1.0-SNAPSHOT.jar -output_dir_path=../signed/ 
   ```
   <details>
      <summary>Command Output</summary>
   
   ```shell
   $ ./CodeSignTool.sh sign -credential_id=8b072e22-7685-4771-b5c6-48e46614915f -username=esigner_demo -password="esignerDemo#1" -input_file_path=../cool-app/target/cool-app-1.0-SNAPSHOT.jar -output_dir_path=../signed/
   Enter the OTP - Press enter to continue: 207138
   Code signed successfully: /Users/bhamail/sonatype/sasq/CodeSigningSSLTest/CodeSignTool-v1.3.0/../signed/cool-app-1.0-SNAPSHOT.jar
   ```
   </details>

   The signed jar will be in the [signed](signed) directory.
8. Verify the signed jar using `jarsigner` (part of the jdk):
   ```shell
   cd ..
   jarsigner -verify signed/cool-app-1.0-SNAPSHOT.jar
   ```
   <details>
      <summary>Command Output</summary>

   ```shell
   $ jarsigner -verify signed/cool-app-1.0-SNAPSHOT.jar
   jar verified.
   
   Warning:
   This jar contains entries whose certificate chain is invalid. Reason: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
   
   Re-run with the -verbose and -certs options for more details.
   ```
   </details>
