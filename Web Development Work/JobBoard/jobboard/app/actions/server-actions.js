"use server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import ApplicationRepo from "@/app/repo/application-repo";

const appRepo = new ApplicationRepo();

function removeServerActionProperty(data) {
  // this is a helper function to remove the $ACTION_ID_ prefix from the keys
  for (const key in data) {
    if (key.startsWith("$ACTION_ID_")) {
      delete data[key];
      break;
    }
  }

  return data;
}

export async function getJobsAction(status) {
  return await appRepo.getJobs(status ? status : undefined);
}

export async function getApplicationsAction() {
  return await appRepo.getApplications();
}

export async function getJobAction(id) {
  return await appRepo.getJob(id);
}

export async function addApplicationAction(formData) {
  let application = Object.fromEntries(formData);

  application = removeServerActionProperty(application);

  application.jobId = Number(application.jobId);

  delete application.id;

  console.log(application);

  await appRepo.addApplication(application);

  redirect("/");
}

export async function deleteApplicationAction(id) {
  await appRepo.deleteApplication(id);
}

export async function updateJobAction(id, status) {}
