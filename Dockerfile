FROM ubuntu:latest

WORKDIR /home/cpvbox/Sysad2

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y sudo && \
    apt-get clean && \
    apt-get install acl && \
    rm -rf /var/lib/apt/lists/*

# Copy the server setup files to the container
COPY userGen.sh /home/cpvbox/Sysad2
COPY domainPref.sh /home/cpvbox/Sysad2
COPY mentorAllocation.sh /home/cpvbox/Sysad2
COPY displayStatus.sh /home/cpvbox/Sysad2
COPY submitTask.sh /home/cpvbox/Sysad2
COPY mentorDetails.txt /home/cpvbox/Sysad2
COPY menteeDetails.txt /home/cpvbox/Sysad2

# Running the setup scripts
RUN chmod +x /home/cpvbox/Sysad2/userGen.sh
RUN chmod +x /home/cpvbox/Sysad2/domainPref.sh
RUN chmod +x /home/cpvbox/Sysad2/mentorAllocation.sh 
RUN chmod +x /home/cpvbox/Sysad2/displayStatus.sh 
RUN chmod +x /home/cpvbox/Sysad2/submitTask.sh 

RUN ./userGen.sh

# Expose the required ports
EXPOSE 80 443

# Set the entry point to keep the container running
CMD ["tail", "-f", "/dev/null"]
