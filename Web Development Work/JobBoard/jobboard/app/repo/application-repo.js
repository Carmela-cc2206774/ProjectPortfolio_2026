import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

class ApplicationRepo {
  async getJobs(status) {
    return await prisma.job.findMany({
      where: status ? { isActive: status } : undefined,
      include: { applications: true },
    });
  }

  async getApplications() {
    return await prisma.application.findMany({});
  }

  async getApplicationsCount() {
    return (await prisma.application.findMany({})).length;
  }

  async getActiveJobsCount() {
    return (await prisma.job.findMany({ where: { isActive: true } })).length;
  }

  async getJob(id) {
    return await prisma.job.findUnique({ where: { id } });
  }

  async getJobApplication(id) {
    const jobs = await prisma.job.aggregate({
      _count: { applications: true },
    });
  }

  async addApplication(newApplicaton) {
    await prisma.application.create({ data: newApplicaton });
  }
  async deleteApplication(id) {
    await prisma.application.delete({ where: { id } });
  }
  async updateJob(id, status) {
    await prisma.job.update({ data: { isActive: status }, where: { id } });
  }
}

export default ApplicationRepo;

/*

•getJobs(status?) // Return all jobs with their applications, with optional status filtering
• getJob(id) // Retrieve a specific job by ID with its applications
• addApplication(newApplicaton) // Add a new application
• deleteApplication(id) // Remove an application by ID
• updateJob(id, status) //updates the applications isActive with the given status

*/
