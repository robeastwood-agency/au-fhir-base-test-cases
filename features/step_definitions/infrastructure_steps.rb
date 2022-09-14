
Given('a test file named {string} exists') do |testfile|
  @testfile = testfile
  expect(@testfile).to be_in_testcase_directory
end

When('I run the validator command on this testfile against profile {string}') do |profile_id|

  cmd = TTY::Command.new(printer: :null)

  # determine if the feature is being run on Windows or on Linux (GitHub action)
  # on Windows 
  if Gem::Platform.local.os == "mingw32"
    # on my personal laptop
    if Socket.gethostname == "LAPTOP-KL85GOQC"
      path_to_validator = "C\:\\Users\\rob\\Documents\\PC_stuff\\software\\FHIR\\validator\\validator_cli.jar"
    else
      path_to_validator = "C\:\\work\\tools\\FHIR-validator\\validator_cli.jar"
    end
  # otherwise in Github action
  else
    path_to_validator = "validator.jar"
  end

   profile_url = "#{PROFILE_BASE}#{profile_id}"

  # term_server = "https://r4.ontoserver.csiro.au/fhir"
  # term_server = "n/a"
  # -tx #{term_server}  

  validator_command = "java -jar #{path_to_validator} -version #{FHIR_VERSION} #{@testfile} -ig #{IG_PACKAGE} -profile #{profile_url} -level errors"

  begin

    if not(File.exist?(path_to_validator))
      raise ValidatorNotPresentError
    else
      Kernel.puts "      Running validation command..."
      @output, @err = cmd.run(validator_command)
    end
  
  rescue TTY::Command::ExitError => e
    # Kernel.puts e.to_s
    @output = e.to_s
    true

  rescue ValidatorNotPresentError => e
    # Kernel.puts e.to_s
    expect(path_to_validator).to be_accessible

  end 

end

Then('the command should {string} with output message {string}') do |status, output_string|
  expect(@output).to include_correct_content(status, output_string)
end