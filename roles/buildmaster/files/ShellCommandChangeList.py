from twisted.python import log
from buildbot.steps import shell
from buildbot.process.buildstep import RemoteShellCommand
 
# Executes a remote command with changed files appended onto the end
class ShellCommandChangeList(shell.ShellCommand):
	def start(self):
		# Substitute build properties into command
		#command = self._interpolateProperties(self.command)
		command = self.command
		# fail assert if command is not of correct type
		assert isinstance(command, (list, tuple, str))

		# Get changed file list from the build which invoked this step
		files = self.build.allFiles()

		# Now we can do whatever we want with the list of changed files.
		# I will just append them to the end of the command.

		## IGNORE THIS
		#log.msg("Build Files (STR): %s" % files)
		#files = " -t {quot}{files}{quot}".format(files=" ".join(files),quot='"')
		#command += files
		#log.msg("Build Files (TUPLE): %s" % files)
		#command += tuple(["-t", "{files}".format(files=" ".join(files))])
		#elif isinstance(command, list):
		#	log.msg("Build Files (LIST): %s" % files)
		#	command += ["-t", "{files}".format(files=" ".join(files))]

		# Convert file list so it can be appended to the command's type
		if isinstance(command, str):
			files = " ".join(files)
		elif isinstance(command, tuple):
			files = tuple(files)

		# .. and append files to end of command
		# (the type 'lists' is not handled above because it doesn't have to be)
		command += files

		# We have created the final command string
		# so we can fill out the arguments for a RemoteShellCommand
		# using our new command string
		kwargs = self.remote_kwargs
		kwargs['command'] = command
		kwargs['logfiles'] = self.logfiles
		kwargs['timeout'] = 3600

		# Create the RemoteShellCommand and start it
		cmd = RemoteShellCommand(**kwargs)
		self.setupEnvironment(cmd)
		#self.checkForOldSlaveAndLogfiles()
		self.startCommand(cmd)
